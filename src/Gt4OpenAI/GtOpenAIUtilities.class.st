Class {
	#name : #GtOpenAIUtilities,
	#superclass : #Object,
	#category : #'Gt4OpenAI-Utilities'
}

{ #category : #executing }
GtOpenAIUtilities class >> executionConfiguration [
	^ AsyncFutureExecutionConfiguration new
		customGroup: #OpenAI;
		lowPriority
]
