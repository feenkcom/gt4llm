Class {
	#name : #GtLAnthropicSettings,
	#superclass : #Object,
	#category : 'Gt4Llm-Anthropic-Provider'
}

{ #category : #settings }
GtLAnthropicSettings class >> futureExecutionConfiguration [
	^ AsyncFutureExecutionConfiguration new
		customGroup: #Anthropic;
		lowPriority
]
