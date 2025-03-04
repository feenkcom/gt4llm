Extension { #name : #GtLlmTutor }

{ #category : #'*Gt4Anthropic' }
GtLlmTutor >> defaultAnthropicProviderStencilWithModel: aModel [
	^ [ :anInstructionFormat | 
	GtAnthropicProvider withApiKeyFromFile
		model: aModel;
		instructions: anInstructionFormat asInstructionPiece instructionString;
		assistantMessageClass: GtLlmActionMessage;
		userMessageClass: GtLlmActionMessage ]
]
