Class {
	#name : #Gt4OpenAIUtilities,
	#superclass : #Object,
	#category : #'Gt4OpenAI-Utilities'
}

{ #category : #executing }
Gt4OpenAIUtilities class >> executionConfiguration [
	^ AsyncFutureExecutionConfiguration new
		customGroup: #OpenAI;
		lowPriority
]
