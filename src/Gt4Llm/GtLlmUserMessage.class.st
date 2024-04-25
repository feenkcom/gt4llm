Class {
	#name : #GtLlmUserMessage,
	#superclass : #GtLlmChatMessage,
	#category : #'Gt4Llm-Models'
}

{ #category : #accessing }
GtLlmUserMessage class >> defaultRole [
	^ 'user'
]
