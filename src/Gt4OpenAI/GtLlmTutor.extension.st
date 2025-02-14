Extension { #name : #GtLlmTutor }

{ #category : #'*Gt4OpenAI' }
GtLlmTutor >> defaultProviderStencil [
	^ [ :anInstructionFormat | 
	GtOpenAIAssistantProvider withApiKeyFromFile
		instructions: anInstructionFormat asInstructionPiece instructionString;
		format: anInstructionFormat asJsonSchema ]
]
