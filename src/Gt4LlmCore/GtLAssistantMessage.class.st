Class {
	#name : #GtLAssistantMessage,
	#superclass : #GtLChatMessage,
	#category : #Gt4LlmCore
}

{ #category : #accessing }
GtLAssistantMessage class >> defaultRole [
	^ 'assistant'
]

{ #category : #accessing }
GtLAssistantMessage class >> leJsonV4Name [

	^ #gtLAssistantMessage
]

{ #category : #visiting }
GtLAssistantMessage >> acceptVisitor: aVisitor [

	^ aVisitor visitGtLlmAssistantMessage: self
]
