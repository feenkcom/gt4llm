Class {
	#name : #GtLlmSystemMessage,
	#superclass : #GtLlmChatMessage,
	#category : #'Gt4Llm-Models'
}

{ #category : #accessing }
GtLlmSystemMessage class >> defaultRole [
	^ 'system'
]
