Class {
	#name : #GtLlmUserMessage,
	#superclass : #GtLlmChatMessage,
	#category : #Gt4Llm
}

{ #category : #accessing }
GtLlmUserMessage class >> defaultRole [
	^ 'user'
]
