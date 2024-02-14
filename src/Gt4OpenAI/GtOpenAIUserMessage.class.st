Class {
	#name : #GtOpenAIUserMessage,
	#superclass : #GtOpenAIChatMessage,
	#category : #'Gt4OpenAI-Models'
}

{ #category : #accessing }
GtOpenAIUserMessage class >> defaultRole [
	^ 'user'
]
