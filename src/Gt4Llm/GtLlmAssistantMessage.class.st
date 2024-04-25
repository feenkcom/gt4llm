Class {
	#name : #GtLlmAssistantMessage,
	#superclass : #GtLlmChatMessage,
	#category : #'Gt4Llm-Models'
}

{ #category : #accessing }
GtLlmAssistantMessage class >> defaultRole [
	^ 'assistant'
]
