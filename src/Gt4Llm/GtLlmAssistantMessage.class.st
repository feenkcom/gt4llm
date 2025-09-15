Class {
	#name : #GtLlmAssistantMessage,
	#superclass : #GtLlmChatMessage,
	#category : #Gt4Llm
}

{ #category : #accessing }
GtLlmAssistantMessage class >> defaultRole [
	^ 'assistant'
]

{ #category : #accessing }
GtLlmAssistantMessage class >> leJsonV4Name [

	^ #gtLlmAssistantMessage
]

{ #category : #visiting }
GtLlmAssistantMessage >> acceptVisitor: aVisitor [

	^ aVisitor visitGtLlmAssistantMessage: self
]
