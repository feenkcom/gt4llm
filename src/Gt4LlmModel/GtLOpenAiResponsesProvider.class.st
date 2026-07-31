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

{ #category : #testing }
GtLOpenAiResponsesProvider >> assistantMessageHasCompactionResponse: anAssistantMessage [
	"Answer a boolean indicating whether the provided message contains a compaction response.
	E.g. OpenAI will include an encrypted_content output for server-side compaction."
	| response |
	
	response := anAssistantMessage requestResponse result.
	^ response output anySatisfy: [ :jsonObject |
		(jsonObject at: 'type' ifAbsent: []) = 'compaction' ].
]

{ #category : #initialization }
GtLOpenAiResponsesProvider >> initialize [

	super initialize.
	model
		provider: self;
		client: GtLModelOpenAiClient new loadApiKeyFromFile.
	self responses.
]
