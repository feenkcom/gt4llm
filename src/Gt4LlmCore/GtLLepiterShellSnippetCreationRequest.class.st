"
Request for creating a shell snippet.
"
Class {
	#name : #GtLLepiterShellSnippetCreationRequest,
	#superclass : #GtLLepiterTextualSnippetCreationRequest,
	#category : #'Gt4LlmCore-Magritte Objects'
}

{ #category : #'json schema' }
GtLLepiterShellSnippetCreationRequest class >> jsonSchemaLabel [
	^ 'ShellSnippet'
]

{ #category : #building }
GtLLepiterShellSnippetCreationRequest >> buildSnippetFor: aTool [
	^ LeShellScriptSnippet code: self snippetText asString
]

{ #category : #accessing }
GtLLepiterShellSnippetCreationRequest >> shellCode [
	^ self snippetText
]

{ #category : #accessing }
GtLLepiterShellSnippetCreationRequest >> shellCode: aString [
	self snippetText: aString
]

{ #category : #magritte }
GtLLepiterShellSnippetCreationRequest >> shellCodeDescription [
	<magritteDescription>

	^ MAStringDescription new
		label: 'Shell code';
		comment: 'Shell code for the snippet.';
		accessor: #shellCode;
		beRequired;
		yourself
]

{ #category : #validation }
GtLLepiterShellSnippetCreationRequest >> validateSnippetArgumentsFor: aTool ifCorrect: aBlock [
	(snippetText isNil or: [ snippetText asString isEmpty ])
		ifTrue: [ ^ GtLMissingArgumentDomainObject new
			arguments: self;
			missingArgument: 'snippetText' ].
	^ aBlock value
]
