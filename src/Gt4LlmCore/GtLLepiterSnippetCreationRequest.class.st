Class {
	#name : #GtLLepiterSnippetCreationRequest,
	#superclass : #Object,
	#instVars : [
		'pageUid'
	],
	#category : #Gt4LlmCore
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

{ #category : #validation }
GtLLepiterSnippetCreationRequest >> validateSnippetArgumentsFor: aTool ifCorrect: aBlock [
	self subclassResponsibility
]
