Extension { #name : #GtLlmAssistant }

{ #category : #'*Gt4Ollama' }
GtLlmAssistant >> onOllamaWithModel: aModel [
	self providerStencil: (self defaultOllamaProviderStencilWithModel: aModel)
]
