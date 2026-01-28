Class {
	#name : #GtLOpenAISettings,
	#superclass : #Object,
	#category : #'Gt4Llm-OpenAI-Support'
}

{ #category : #settings }
GtLOpenAISettings class >> futureExecutionConfiguration [
	^ AsyncFutureExecutionConfiguration new
		customGroup: #OpenAI;
		lowPriority
]
