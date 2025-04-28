Extension { #name : #GtLlmAssistant }

{ #category : #'*Gt4OpenAI' }
GtLlmAssistant >> defaultProviderStencil [
	^ [ :anInstructionFormat | 
	GtOpenAIResponseProvider withApiKeyFromFile
		instructions: anInstructionFormat asInstructionPiece instructionString;
		format: anInstructionFormat asJsonSchema;
		assistantMessageClass: GtOpenAIActionMessage;
		userMessageClass: GtOpenAIActionMessage ]
]
