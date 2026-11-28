Class {
	#name : #GtLLepiterSnippetCreationRequest,
	#superclass : #Object,
	#instVars : [
		'pageUid',
		'parentSnippetUid',
		'databaseId'
	],
	#category : #'Gt4LlmCore-Magritte Objects'
}

{ #category : #'json schema' }
GtLLepiterSnippetCreationRequest class >> jsonSchemaLabel [
	^ "self snippetTypeValue capitalized , 'Snippet'" self subclassResponsibility
]

{ #category : #'instance creation' }
GtLLepiterSnippetCreationRequest class >> requestClassForType: aString [
	| normalizedType |
	normalizedType := aString ifNil: [ '' ] ifNotNil: [ aString asString trimBoth ].
	normalizedType isEmpty ifTrue: [ normalizedType := 'text' ].
	^ {
		'text' -> GtLLepiterTextSnippetCreationRequest.
		'pharo' -> GtLLepiterPharoSnippetCreationRequest.
		'python' -> GtLLepiterPythonSnippetCreationRequest.
		'shell' -> GtLLepiterShellSnippetCreationRequest.
		'example' -> GtLLepiterExampleSnippetCreationRequest.
		'picture' -> GtLLepiterPictureSnippetCreationRequest } asDictionary
			at: normalizedType
			ifAbsent: [ self ]
]

{ #category : #building }
GtLLepiterSnippetCreationRequest >> buildSnippetFor: aTool [
	self subclassResponsibility
]

{ #category : #accessing }
GtLLepiterSnippetCreationRequest >> databaseId [
	^ databaseId
]

{ #category : #accessing }
GtLLepiterSnippetCreationRequest >> databaseId: aString [
	databaseId := aString
]

{ #category : #magritte }
GtLLepiterSnippetCreationRequest >> databaseIdDescription [
	<magritteDescription>
	^ MAStringDescription new
		label: 'Database id';
		accessor: #databaseId;
		comment: 'Optional id of the database of the page, from lepiterKnowledgeBases. Needed only when the page id is in several databases: the errorMessage then lists them.';
		yourself
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
		accessor: #pageUid;
		comment: 'The id of the page (base 36), from searchForLepiterPages or createLepiterPage.';
		beRequired
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
		accessor: #parentSnippetUid;
		comment: 'Optional id of a snippet of the page (base 64), from getLepiterPageContents with format structure or from createLepiterSnippets. The new snippet becomes its last child.';
		yourself
]

{ #category : #validation }
GtLLepiterSnippetCreationRequest >> validateSnippetArgumentsFor: aTool ifCorrect: aBlock [
	self subclassResponsibility
]
