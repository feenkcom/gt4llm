"
Request for creating a Python snippet.
"
Class {
	#name : #GtLLepiterPythonSnippetCreationRequest,
	#superclass : #GtLLepiterTextualSnippetCreationRequest,
	#category : 'Gt4LlmCore-Magritte Objects'
}

{ #category : #'json schema' }
GtLLepiterPythonSnippetCreationRequest class >> jsonSchemaLabel [
	^ 'PythonSnippet'
]

{ #category : #building }
GtLLepiterPythonSnippetCreationRequest >> buildSnippetFor: aTool [
	^ LePythonSnippet code: self snippetText asString
]

{ #category : #accessing }
GtLLepiterPythonSnippetCreationRequest >> pythonCode [
	^ self snippetText
]

{ #category : #accessing }
GtLLepiterPythonSnippetCreationRequest >> pythonCode: aString [
	self snippetText: aString
]

{ #category : #magritte }
GtLLepiterPythonSnippetCreationRequest >> pythonCodeDescription [
	<magritteDescription>

	^ MAStringDescription new
		label: 'Python code';
		comment: 'Python code for the snippet.';
		accessor: #pythonCode;
		beRequired;
		yourself
]

{ #category : #validation }
GtLLepiterPythonSnippetCreationRequest >> validateSnippetArgumentsFor: aTool ifCorrect: aBlock [
	(snippetText isNil or: [ snippetText asString isEmpty ])
		ifTrue: [ ^ GtLMissingArgumentDomainObject new
			arguments: self;
			missingArgument: 'snippetText' ].
	^ aBlock value
]
