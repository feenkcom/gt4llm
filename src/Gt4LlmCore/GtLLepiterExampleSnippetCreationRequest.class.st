"
Request for creating an example snippet.
"
Class {
	#name : #GtLLepiterExampleSnippetCreationRequest,
	#superclass : #GtLLepiterSnippetCreationRequest,
	#instVars : [
		'exampleClassName',
		'exampleMethodName'
	],
	#category : #Gt4LlmCore
}

{ #category : #'json schema' }
GtLLepiterExampleSnippetCreationRequest class >> jsonSchemaLabel [
	^ 'ExampleSnippet'
]

{ #category : #building }
GtLLepiterExampleSnippetCreationRequest >> buildSnippetFor: aTool [
	^ LeExampleSnippet new
		exampleBehaviorName: self exampleClassName asString;
		exampleSelector: self exampleMethodName
]

{ #category : #accessing }
GtLLepiterExampleSnippetCreationRequest >> exampleClassName [
	^ exampleClassName
]

{ #category : #accessing }
GtLLepiterExampleSnippetCreationRequest >> exampleClassName: aString [
	exampleClassName := aString
]

{ #category : #magritte }
GtLLepiterExampleSnippetCreationRequest >> exampleClassNameDescription [
	<magritteDescription>

	^ MAStringDescription new
		label: 'Example class name';
		accessor: #exampleClassName;
		beRequired
]

{ #category : #accessing }
GtLLepiterExampleSnippetCreationRequest >> exampleMethodName [
	^ exampleMethodName
]

{ #category : #accessing }
GtLLepiterExampleSnippetCreationRequest >> exampleMethodName: aString [
	exampleMethodName := aString
]

{ #category : #magritte }
GtLLepiterExampleSnippetCreationRequest >> exampleMethodNameDescription [
	<magritteDescription>

	^ MAStringDescription new
		label: 'Example method name';
		accessor: #exampleMethodName;
		beRequired
]

{ #category : #validation }
GtLLepiterExampleSnippetCreationRequest >> validateSnippetArgumentsFor: aTool ifCorrect: aBlock [
	(exampleClassName isNil or: [ exampleClassName trimBoth isEmpty ])
		ifTrue: [ ^ GtLMissingArgumentDomainObject new
				arguments: self;
				missingArgument: 'exampleClassName' ].
	(exampleMethodName isNil or: [ exampleMethodName trimBoth isEmpty ])
		ifTrue: [ ^ GtLMissingArgumentDomainObject new
				arguments: self;
				missingArgument: 'exampleMethodName' ].
	^ aBlock value
]
