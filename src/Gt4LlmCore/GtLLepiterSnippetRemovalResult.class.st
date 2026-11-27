"
I describe a snippet that was removed: `removedSnippet` is its snapshot before the removal. My status is 'removed'.

Removing a snippet removes its descendants too:
- the result of the snippet that was asked for has `removedChildResults`, the results of its descendants, depth first; its JSON adds `removedChildSnippetUids`;
- the result of a descendant has `removedWithSnippet`, the reference of the snippet that was asked for.
"
Class {
	#name : #GtLLepiterSnippetRemovalResult,
	#superclass : #GtLLepiterSnippetChangeResult,
	#instVars : [
		'removedSnippet',
		'removedWithSnippet',
		'removedChildResults'
	],
	#category : #'Gt4LlmCore-Magritte Objects'
}

{ #category : #accessing }
GtLLepiterSnippetRemovalResult >> allResults [
	^ {self} , (self removedChildResults flatCollect: [ :each | each allResults ])
]

{ #category : #views }
GtLLepiterSnippetRemovalResult >> gtViewChangeIcon [
	^ self class removalIcon
]

{ #category : #initialization }
GtLLepiterSnippetRemovalResult >> initialize [
	super initialize.
	status := 'removed'
]

{ #category : #testing }
GtLLepiterSnippetRemovalResult >> isReportedOnItsOwn [
	"A snippet removed with an ancestor is listed in the removedChildSnippetUids of that ancestor"

	^ removedWithSnippet isNil
]

{ #category : #testing }
GtLLepiterSnippetRemovalResult >> isSnippetRemovalResult [
	^ true
]

{ #category : #accessing }
GtLLepiterSnippetRemovalResult >> llmChangeEntry [
	"The entry of a removed snippet lists the descendants removed with it, as removeLepiterSnippets does"

	^ super llmChangeEntry
		removedChildSnippetUids: self removedChildSnippetUids;
		yourself
]

{ #category : #refactoring }
GtLLepiterSnippetRemovalResult >> llmChangeKind [
	^ 'removed snippet'
]

{ #category : #accessing }
GtLLepiterSnippetRemovalResult >> oldStateSnippet [
	^ removedSnippet
]

{ #category : #accessing }
GtLLepiterSnippetRemovalResult >> removedChildResults [
	"Return the results of my descendants, depth first, when I am the snippet that was asked for"

	^ removedChildResults ifNil: [ #() ]
]

{ #category : #accessing }
GtLLepiterSnippetRemovalResult >> removedChildResults: aCollection [
	removedChildResults := aCollection asArray
]

{ #category : #accessing }
GtLLepiterSnippetRemovalResult >> removedChildSnippetUids [
	"The uids of the removed descendants, for the JSON of the snippet that was asked for; nil otherwise, so the key is left out"

	self removedChildResults ifEmpty: [ ^ nil ].
	^ self removedChildResults
		collect: [ :each | each targetSnippetReference snippetUid ]
		as: Array
]

{ #category : #magritte }
GtLLepiterSnippetRemovalResult >> removedChildSnippetUidsDescription [
	"Only the result of the snippet that was asked for, when it had descendants, lists them. Magritte builds the descriptions of each object, and leaves out a nil one"

	<magritteDescription>
	self removedChildResults ifEmpty: [ ^ nil ].
	^ MAToManyScalarRelationDescription new
		label: 'Removed child snippet uids';
		accessor: #removedChildSnippetUids;
		classes: {String};
		priority: 3;
		comment: 'The ids of the descendants removed with the snippet, depth first.';
		yourself
]

{ #category : #accessing }
GtLLepiterSnippetRemovalResult >> removedSnippet [
	^ removedSnippet
]

{ #category : #accessing }
GtLLepiterSnippetRemovalResult >> removedSnippet: aSnippetWithContent [
	removedSnippet := aSnippetWithContent
]

{ #category : #accessing }
GtLLepiterSnippetRemovalResult >> removedWithSnippet [
	"Return the reference of the snippet whose removal removed me, or nil if I am the snippet that was asked for"

	^ removedWithSnippet
]

{ #category : #accessing }
GtLLepiterSnippetRemovalResult >> removedWithSnippet: aSnippetReferenceOrNil [
	removedWithSnippet := aSnippetReferenceOrNil
]

{ #category : #accessing }
GtLLepiterSnippetRemovalResult >> targetSnippet [
	^ removedSnippet
]
