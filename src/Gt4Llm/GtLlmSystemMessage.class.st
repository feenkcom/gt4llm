Class {
	#name : #GtLlmSystemMessage,
	#superclass : #GtLlmChatMessage,
	#category : #Gt4Llm
}

{ #category : #accessing }
GtLlmSystemMessage class >> defaultRole [
	^ 'system'
]
