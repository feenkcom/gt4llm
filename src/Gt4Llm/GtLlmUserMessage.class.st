Class {
	#name : #GtLlmUserMessage,
	#superclass : #GtLlmChatMessage,
	#category : #Gt4Llm
}

{ #category : #accessing }
GtLlmUserMessage class >> defaultRole [
	^ 'user'
]

{ #category : #accessing }
GtLlmUserMessage class >> leJsonV4Name [

	^ #gtLlmUserMessage
]

{ #category : #visiting }
GtLlmUserMessage >> acceptVisitor: aVisitor [

	^ aVisitor visitGtLlmUserMessage: self
]
