Class {
	#name : #GtLlmSystemMessage,
	#superclass : #GtLlmChatMessage,
	#category : #Gt4Llm
}

{ #category : #accessing }
GtLlmSystemMessage class >> defaultRole [
	^ 'system'
]

{ #category : #accessing }
GtLlmSystemMessage class >> leJsonV4Name [

	^ #gtLlmSystemMessage
]

{ #category : #visiting }
GtLlmSystemMessage >> acceptVisitor: aVisitor [

	^ aVisitor visitGtLlmSystemMessage: self
]
