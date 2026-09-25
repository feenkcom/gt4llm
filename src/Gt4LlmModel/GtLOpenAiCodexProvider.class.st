Class {
	#name : #GtLOpenAiCodexProvider,
	#superclass : #GtLOpenAiResponsesProvider,
	#category : #'Gt4LlmModel-Codex'
}

{ #category : #accessing }
GtLOpenAiCodexProvider class >> providerName [
	^ 'OpenAI Codex'
]

{ #category : #'instance creation' }
GtLOpenAiCodexProvider class >> withDefaultSetup [
	^ self new
]

{ #category : #accessing }
GtLOpenAiCodexProvider >> credential [
	^ model client credential
]

{ #category : #accessing }
GtLOpenAiCodexProvider >> credential: aCredential [
	model client credential: aCredential.
	^ self
]

{ #category : #initialization }
GtLOpenAiCodexProvider >> initialize [
	executionState := GtLProviderState idle.
	model := GtLLlmModel new.
	compactionStrategy := GtLNoCompactionStrategy forProvider: self.
	model provider: self; client: GtLOpenAiCodexClient new.
	self responses
]

{ #category : #initialization }
GtLOpenAiCodexProvider >> responses [
	| endpoint |
	endpoint := GtLOpenAiCodexResponsesEndpoint new.
	model endpointAt: 'userMessage' put: endpoint.
	model
		optionAt: 'dataSourceRequestParser' put: (GtLDataSourceOpenAiResponsesRequestParser new model: model);
		optionAt: 'dataSourceResponseParser' put: (GtLDataSourceOpenAiResponsesResponseParser new model: model).
	^ model
]
