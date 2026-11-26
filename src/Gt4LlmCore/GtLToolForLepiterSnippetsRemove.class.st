Class {
	#name : #GtLToolForLepiterSnippetsRemove,
	#superclass : #GtLAbstractLepiterSnippetTool,
	#category : #'Gt4LlmCore-Tools'
}

{ #category : #accessing }
GtLToolForLepiterSnippetsRemove >> description [
	^ 'Removes one or more Lepiter snippets, identified by their page ids (base 36, as getLepiterPageContents gives them) and snippet ids. Removing a snippet also removes its child snippets.

The optional databaseId is needed only when the page and snippet ids are in several databases: the response then says so and lists them.

Example JSON arguments:
{
  "snippets": [
    {"pageUid": "PAGE_ID", "snippetUid": "SNIPPET_ID"},
    {"databaseId": "DATABASE_ID", "pageUid": "PAGE_ID", "snippetUid": "SNIPPET_ID"}
  ]
}

The response has one entry per requested snippet, in order: the result, or an errorMessage. The result of a snippet that had child snippets lists their uids, depth first, in removedChildSnippetUids. A snippet that is listed after one of its ancestors, or twice, is answered with an errorMessage saying that it was already removed.

Example JSON response:
{
  "snippets": [
    {"status": "removed", "targetSnippetReference": {"databaseId": "DATABASE_ID", "pageUid": "PAGE_ID", "snippetUid": "SNIPPET_ID"}, "removedChildSnippetUids": ["CHILD_SNIPPET_ID"]},
    {"status": "removed", "targetSnippetReference": {"databaseId": "DATABASE_ID", "pageUid": "PAGE_ID", "snippetUid": "SNIPPET_ID"}}
  ]
}'
]

{ #category : #accessing }
GtLToolForLepiterSnippetsRemove >> name [
	^ 'removeLepiterSnippets'
]

{ #category : #private }
GtLToolForLepiterSnippetsRemove >> privatePerformToolCall: aToolCall inContext: anExecutionContext [
	| results |
	results := OrderedCollection new.
	(aToolCall arguments at: 'snippets')
		do: [ :each | results add: (self removeSnippetFrom: each after: results) ].
	^ GtLLepiterSnippetsChangeResult new
		snippetResults: results;
		yourself
]

{ #category : #private }
GtLToolForLepiterSnippetsRemove >> problemOfRemovedEarlier: aRemovalRequest in: theEarlierResults [
	"Return an error if the snippet was already removed earlier in this call, itself or with an ancestor, or nil. Without it, the snippet would only be reported as not found"

	theEarlierResults
		do: [ :each | 
			each isErrorDomainObject
				ifFalse: [ each allResults
						do: [ :aResult | 
							(self isReference: aResult targetSnippetReference requestedBy: aRemovalRequest)
								ifTrue: [ ^ GtLProblemDomainObject new
										errorMessage: 'The snippet ' , aRemovalRequest snippetUid asString trimBoth
												, ' was already removed earlier in this call'
												, (aResult == each
														ifTrue: [ '' ]
														ifFalse: [ ', with its ancestor ' , each targetSnippetReference snippetUid
																, ' (see the removedChildSnippetUids of that snippet)' ]) , '.';
										yourself ] ] ] ].
	^ nil
]

{ #category : #private }
GtLToolForLepiterSnippetsRemove >> removeSnippetFrom: aRemovalRequest after: theEarlierResults [
	"Remove the snippet with its descendants, and answer its removal result, which holds the results of the descendants. theEarlierResults are those of the snippets asked for before in the same call"

	| snippet removedSnippet removedDescendants |
	(self missingArgumentAmong: #('pageUid' 'snippetUid') in: aRemovalRequest)
		ifNotNil: [ :aProblem | ^ aProblem ].
	(self problemOfRemovedEarlier: aRemovalRequest in: theEarlierResults)
		ifNotNil: [ :aProblem | ^ aProblem ].
	snippet := self snippetFrom: aRemovalRequest ifNone: [ :aProblem | ^ aProblem ].	"The snapshots are taken before the removal, which also removes the descendants"
	removedSnippet := GtLLepiterSnippetWithContent fromSnippet: snippet.
	removedDescendants := OrderedCollection new.
	snippet
		allChildrenDepthFirstDo: [ :each | removedDescendants add: (GtLLepiterSnippetWithContent fromSnippet: each) ].
	[ snippet removeSelf ]
		on: Error
		do: [ :error | 
			^ GtLExceptionDomainObject new
				freeze: error;
				errorReason: 'Error while removing snippet' ].
	^ GtLLepiterSnippetRemovalResult new
		removedSnippet: removedSnippet;
		removedChildResults: (removedDescendants
				collect: [ :each | 
					GtLLepiterSnippetRemovalResult new
						removedSnippet: each;
						removedWithSnippet: removedSnippet reference;
						yourself ]);
		yourself
]

{ #category : #private }
GtLToolForLepiterSnippetsRemove >> snippetFrom: aRemovalRequest ifNone: aBlock [
	"Return the snippet named by the request, or the value of aBlock with the problem: not found or ambiguous"

	^ self snippetLocator
		snippetWithUid: aRemovalRequest snippetUid
		pageUid: aRemovalRequest pageUid
		databaseId: aRemovalRequest databaseId
		ifFound: [ :aSnippet | aSnippet ]
		ifNone: aBlock
]

{ #category : #magritte }
GtLToolForLepiterSnippetsRemove >> snippetsDescription [
	<magritteDescription>

	^ MAToManyRelationDescription new
		label: 'Snippets';
		accessor: #snippets;
		classes: { GtLLepiterSnippetRemovalRequest };
		beRequired
]
