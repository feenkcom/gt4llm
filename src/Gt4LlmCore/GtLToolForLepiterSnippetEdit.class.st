Class {
	#name : #GtLToolForLepiterSnippetEdit,
	#superclass : #GtLAbstractLepiterSnippetTool,
	#category : #'Gt4LlmCore-Tools'
}

{ #category : #accessing }
GtLToolForLepiterSnippetEdit >> description [
	^ 'Replaces the text of one Lepiter snippet, identified by its page id (base 36, as getLepiterPageContents gives it) and snippet id. To edit several snippets in one call, use editLepiterSnippets. Only textual snippets (text, pharo, python, shell and other code snippets) have a text; other snippets, such as example or picture snippets, are refused.

The optional databaseId is needed only when the page and snippet ids are in several databases: the response then says so and lists them.

Example JSON arguments:
{"snippetEdit": {"pageUid": "PAGE_ID", "snippetUid": "SNIPPET_ID", "updatedText": "New text"}}

Example JSON response:
{"status": "updated", "targetSnippetReference": {"databaseId": "DATABASE_ID", "pageUid": "PAGE_ID", "snippetUid": "SNIPPET_ID"}}'
]

{ #category : #private }
GtLToolForLepiterSnippetEdit >> editSnippetFrom: anEditRequest [
	"Replace the text of the snippet that anEditRequest names, and answer its modification result, or an error domain object. editLepiterSnippets edits each of its requests with me"

	| snippet oldSnippet |
	(self
		missingArgumentAmong: #('pageUid' 'snippetUid' 'updatedText')
		in: anEditRequest) ifNotNil: [ :aProblem | ^ aProblem ].
	snippet := self
			snippetToEditFrom: anEditRequest
			ifNone: [ :aProblem | ^ aProblem ].
	oldSnippet := GtLLepiterSnippetWithContent fromSnippet: snippet.
	[ snippet updateString: anEditRequest updatedText ]
		on: Error
		do: [ :error | 
			^ GtLExceptionDomainObject new
				freeze: error;
				errorReason: 'Error while applying snippet change' ].
	^ GtLLepiterSnippetModificationResult new
		oldSnippet: oldSnippet;
		newSnippet: (GtLLepiterSnippetWithContent fromSnippet: snippet);
		yourself
]

{ #category : #accessing }
GtLToolForLepiterSnippetEdit >> name [
	^ 'editLepiterSnippet'
]

{ #category : #private }
GtLToolForLepiterSnippetEdit >> privatePerformToolCall: aToolCall inContext: anExecutionContext [
	^ self editSnippetFrom: (aToolCall arguments at: 'snippetEdit')
]

{ #category : #private }
GtLToolForLepiterSnippetEdit >> refusalToEdit: aSnippet [
	"Return why the snippet cannot be edited, or nil. Only the text of a textual snippet can be replaced"

	| aType |
	(aSnippet isKindOf: LeUnknownSnippet)
		ifTrue: [ ^ GtLProblemDomainObject new
				errorMessage: 'The snippet ' , aSnippet uid uidString
						, ' is of an unknown type (Lepiter could not load its class), so it cannot be edited. Change it in the Glamorous Toolkit, or remove it with removeLepiterSnippets.';
				yourself ].
	(aSnippet isKindOf: LeTextualSnippet) ifTrue: [ ^ nil ].
	aType := GtLLepiterSnippetWithContent snippetTypeOf: aSnippet.
	^ GtLProblemDomainObject new
		errorMessage: 'The snippet ' , aSnippet uid uidString , ' is a snippet of type ' , aType
				, ', which has no text: only the text of textual snippets (text, pharo, python, shell and other code snippets) can be replaced. To change an example or picture snippet, remove it with removeLepiterSnippets and create a new one with createLepiterSnippets: the removal also removes its child snippets, and the new snippet gets a new id and is added at the end of the page or of its parent. Other types can only be changed in the Glamorous Toolkit.';
		yourself
]

{ #category : #magritte }
GtLToolForLepiterSnippetEdit >> snippetEditDescription [
	<magritteDescription>
	^ MAToOneRelationDescription new
		label: 'Snippet edit';
		accessor: #snippetEdit;
		classes: {GtLLepiterSnippetEditRequest};
		beRequired
]

{ #category : #private }
GtLToolForLepiterSnippetEdit >> snippetToEditFrom: anEditRequest ifNone: aBlock [
	"Return the snippet that anEditRequest names, or the value of aBlock with the problem: not found, ambiguous, or not editable"

	| snippet |
	snippet := self snippetLocator
			snippetWithUid: anEditRequest snippetUid
			pageUid: anEditRequest pageUid
			databaseId: anEditRequest databaseId
			ifFound: [ :aSnippet | aSnippet ]
			ifNone: [ :aProblem | ^ aBlock value: aProblem ].
	(self refusalToEdit: snippet)
		ifNotNil: [ :aProblem | ^ aBlock value: aProblem ].
	^ snippet
]
