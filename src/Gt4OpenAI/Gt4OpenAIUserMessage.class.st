Class {
	#name : #Gt4OpenAIUserMessage,
	#superclass : #Gt4OpenAIChatMessage,
	#category : #'Gt4OpenAI-Models'
}

{ #category : #accessing }
Gt4OpenAIUserMessage class >> defaultRole [
	^ 'user'
]
