Class {
	#name : #GtOpenAISystemMessage,
	#superclass : #GtOpenAIChatMessage,
	#category : #'Gt4OpenAI-Models'
}

{ #category : #accessing }
GtOpenAISystemMessage class >> defaultRole [
	^ 'system'
]
