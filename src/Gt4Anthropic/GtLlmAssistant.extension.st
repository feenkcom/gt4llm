Extension { #name : #GtLlmAssistant }

{ #category : #'*Gt4Anthropic' }
GtLlmAssistant >> defaultAnthropicProviderStencilWithModel: aModel [
	^ [ :anInstructionFormat | 
	GtAnthropicProvider withApiKeyFromFile
		model: aModel;
		instructions: anInstructionFormat asInstructionPiece instructionString;
		assistantMessageClass: GtLlmActionMessage;
		userMessageClass: GtLlmActionMessage ]
]
