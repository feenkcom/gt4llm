Class {
	#name : #GtLlmAssistantMessage,
	#superclass : #GtLlmChatMessage,
	#category : #Gt4Llm
}

{ #category : #accessing }
GtLlmAssistantMessage class >> defaultRole [
	^ 'assistant'
]
