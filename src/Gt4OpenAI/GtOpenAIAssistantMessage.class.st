Class {
	#name : #GtOpenAIAssistantMessage,
	#superclass : #GtOpenAIChatMessage,
	#category : #'Gt4OpenAI-Models'
}

{ #category : #accessing }
GtOpenAIAssistantMessage class >> defaultRole [
	^ 'assistant'
]
