Extension { #name : #GtLlmAssistant }

{ #category : #'*Gt4Ollama' }
GtLlmAssistant >> defaultOllamaProviderStencilWithModel: aModel [
	^ [ :anInstructionFormat | 
	GtOllamaProvider new
		model: aModel;
		instructions: anInstructionFormat asInstructionPiece instructionString;
		format: anInstructionFormat asJsonSchema;
		assistantMessageClass: GtLlmActionMessage;
		userMessageClass: GtLlmActionMessage ]
]

{ #category : #'*Gt4Ollama' }
GtLlmAssistant >> onOllamaWithModel: aModel [
	self providerStencil: (self defaultOllamaProviderStencilWithModel: aModel)
]
