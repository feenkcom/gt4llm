"
Request for creating a text snippet.
"
Class {
	#name : #GtLLepiterTextSnippetCreationRequest,
	#superclass : #GtLLepiterTextualSnippetCreationRequest,
	#category : #Gt4LlmCore
}

{ #category : #'json schema' }
GtLLepiterTextSnippetCreationRequest class >> jsonSchemaLabel [
	^ 'TextSnippet'
]

{ #category : #building }
GtLLepiterTextSnippetCreationRequest >> buildSnippetFor: aTool [
	^ LeTextSnippet string: self snippetText asString
]

{ #category : #magritte }
GtLLepiterTextSnippetCreationRequest >> snippetTextDescription [
	<magritteDescription>

	^ MAStringDescription new
		label: 'Snippet text';
		comment: 'Textual content of the snippet.';
		accessor: #snippetText
]

{ #category : #validation }
GtLLepiterTextSnippetCreationRequest >> validateSnippetArgumentsFor: aTool ifCorrect: aBlock [
	(snippetText isNil or: [ snippetText asString isEmpty ])
		ifTrue: [ ^ GtLMissingArgumentDomainObject new
			receiverName: aTool name;
			arguments: self;
			missingArgument: 'snippetText' ].
	^ aBlock value
]
