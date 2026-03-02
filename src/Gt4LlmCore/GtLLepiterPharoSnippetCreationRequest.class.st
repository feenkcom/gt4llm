"
Request for creating a Pharo snippet.
"
Class {
	#name : #GtLLepiterPharoSnippetCreationRequest,
	#superclass : #GtLLepiterTextualSnippetCreationRequest,
	#category : #Gt4LlmCore
}

{ #category : #'json schema' }
GtLLepiterPharoSnippetCreationRequest class >> jsonSchemaLabel [
	^ 'PharoSnippet'
]

{ #category : #building }
GtLLepiterPharoSnippetCreationRequest >> buildSnippetFor: aTool [
	^ LePharoSnippet code: self snippetText asString
]

{ #category : #accessing }
GtLLepiterPharoSnippetCreationRequest >> pharoCode [
	^ self snippetText
]

{ #category : #accessing }
GtLLepiterPharoSnippetCreationRequest >> pharoCode: aString [
	self snippetText: aString
]

{ #category : #magritte }
GtLLepiterPharoSnippetCreationRequest >> pharoCodeDescription [
	<magritteDescription>

	^ MAStringDescription new
		label: 'Pharo code';
		comment: 'Pharo code for the snippet.';
		accessor: #pharoCode
]

{ #category : #validation }
GtLLepiterPharoSnippetCreationRequest >> validateSnippetArgumentsFor: aTool ifCorrect: aBlock [
	(snippetText isNil or: [ snippetText asString isEmpty ])
		ifTrue: [ ^ GtLMissingArgumentDomainObject new
			receiverName: aTool name;
			arguments: self;
			missingArgument: 'snippetText' ].
	^ aBlock value
]
