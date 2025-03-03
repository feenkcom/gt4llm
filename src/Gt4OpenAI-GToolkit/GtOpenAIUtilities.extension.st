Extension { #name : #GtOpenAIUtilities }

{ #category : #'*Gt4OpenAI-GToolkit' }
GtOpenAIUtilities class >> executionConfiguration [
	^ AsyncFutureExecutionConfiguration new
		customGroup: #OpenAI;
		lowPriority
]
