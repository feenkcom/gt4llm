Extension { #name : #GtOpenAIUtilities }

{ #category : #'*Gt4OpenAI-GToolkit' }
GtOpenAIUtilities classSide >> executionConfiguration [
	^ AsyncFutureExecutionConfiguration new
		customGroup: #OpenAI;
		lowPriority
]
