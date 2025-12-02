Class {
	#name : #GtLOpenAIUtilities,
	#superclass : #Object,
	#category : #'Gt4Llm-OpenAI'
}

{ #category : #configuration }
GtLOpenAIUtilities class >> executionConfiguration [
	^ AsyncFutureExecutionConfiguration new
		customGroup: #OpenAI;
		lowPriority
]
