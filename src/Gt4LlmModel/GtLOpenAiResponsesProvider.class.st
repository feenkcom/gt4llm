Class {
	#name : #GtLOpenAiResponsesProvider,
	#superclass : #GtLModelProvider,
	#category : #'Gt4LlmModel-Provider'
}

{ #category : #accessing }
GtLOpenAiResponsesProvider class >> providerName [
	^ 'OpenAI'
]

{ #category : #accessing }
GtLOpenAiResponsesProvider class >> withDefaultSetup [

	^ self new loadApiKeyFromFile
]

{ #category : #initialization }
GtLOpenAiResponsesProvider >> initialize [

	super initialize.
	model
		provider: self;
		client: GtLModelOpenAiClient new loadApiKeyFromFile.
	self responses.
]
