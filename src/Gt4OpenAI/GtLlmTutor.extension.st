Extension { #name : #GtLlmTutor }

{ #category : #'*Gt4OpenAI' }
GtLlmTutor >> defaultProviderStencil [
	^ [ :anInstructionFormat | 
	GtOpenAIResponseProvider withApiKeyFromFile
		instructions: anInstructionFormat asInstructionPiece instructionString;
		format: anInstructionFormat asJsonSchema;
		assistantMessageClass: GtOpenAIActionMessage;
		userMessageClass: GtOpenAIActionMessage ]
]
