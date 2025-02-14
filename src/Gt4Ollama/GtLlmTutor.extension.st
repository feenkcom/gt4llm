Extension { #name : #GtLlmTutor }

{ #category : #'*Gt4Ollama' }
GtLlmTutor >> defaultOllamaProviderStencilWithModel: aModel [
	^ [ :anInstructionFormat | 
	GtOllamaProvider new
		model: aModel;
		instructions: anInstructionFormat asInstructionPiece instructionString;
		format: anInstructionFormat asJsonSchema;
		assistantMessageClass: GtLlmActionMessage;
		userMessageClass: GtLlmActionMessage ]
]

{ #category : #'*Gt4Ollama' }
GtLlmTutor >> onOllamaWithModel: aModel [
	self providerStencil: (self defaultOllamaProviderStencilWithModel: aModel)
]
