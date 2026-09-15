Class {
	#name : #GtLLepiterSnippetCreationRequest,
	#superclass : #Object,
	#instVars : [
		'pageUid',
		'parentSnippetUid'
	],
	#category : #'Gt4LlmCore-Magritte Objects'
}

{ #category : #'json schema' }
GtLLepiterSnippetCreationRequest class >> jsonSchemaLabel [
	^ "self snippetTypeValue capitalized , 'Snippet'" self subclassResponsibility
]

{ #category : #accessing }
GtLLepiterSnippetCreationRequest class >> requestClassForType: aString [
	| normalizedType |
	normalizedType := aString ifNil: [ '' ] ifNotNil: [ aString asString trimBoth ].
	normalizedType isEmpty ifTrue: [ normalizedType := 'text' ].
	^ {
		'text' -> GtLLepiterTextSnippetCreationRequest.
		'pharo' -> GtLLepiterPharoSnippetCreationRequest.
		'python' -> GtLLepiterPythonSnippetCreationRequest.
		'shell' -> GtLLepiterShellSnippetCreationRequest.
		'example' -> GtLLepiterExampleSnippetCreationRequest } asDictionary
			at: normalizedType
			ifAbsent: [ self ]
]

{ #category : #building }
GtLLepiterSnippetCreationRequest >> buildSnippetFor: aTool [
	self subclassResponsibility
]

{ #category : #accessing }
GtLLepiterSnippetCreationRequest >> pageUid [
	^ pageUid
]

{ #category : #accessing }
GtLLepiterSnippetCreationRequest >> pageUid: aString [
	pageUid := aString
]

{ #category : #magritte }
GtLLepiterSnippetCreationRequest >> pageUidDescription [
	<magritteDescription>

	^ MAStringDescription new
		label: 'Page uid';
		accessor: #pageUid
]

{ #category : #accessing }
GtLLepiterSnippetCreationRequest >> parentSnippetUid [
	^ parentSnippetUid
]

{ #category : #accessing }
GtLLepiterSnippetCreationRequest >> parentSnippetUid: aString [
	parentSnippetUid := aString
]

{ #category : #magritte }
GtLLepiterSnippetCreationRequest >> parentSnippetUidDescription [
	<magritteDescription>

	^ MAStringDescription new
		label: 'Parent snippet uid';
		comment: 'Optional uid of the parent snippet. If provided, the new snippet is added as a child of that snippet instead of as a top-level page snippet.';
		accessor: #parentSnippetUid;
		yourself
]

{ #category : #validation }
GtLLepiterSnippetCreationRequest >> validateSnippetArgumentsFor: aTool ifCorrect: aBlock [
	self subclassResponsibility
]
