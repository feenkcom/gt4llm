Class {
	#name : #Gt4OpenAISystemMessage,
	#superclass : #Gt4OpenAIChatMessage,
	#category : #'Gt4OpenAI-Models'
}

{ #category : #accessing }
Gt4OpenAISystemMessage class >> defaultRole [
	^ 'system'
]
