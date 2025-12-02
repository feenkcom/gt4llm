Class {
	#name : #GtLSystemMessage,
	#superclass : #GtLChatMessage,
	#category : #Gt4LlmCore
}

{ #category : #accessing }
GtLSystemMessage class >> defaultRole [
	^ 'system'
]

{ #category : #accessing }
GtLSystemMessage class >> leJsonV4Name [

	^ #gtLSystemMessage
]

{ #category : #visiting }
GtLSystemMessage >> acceptVisitor: aVisitor [

	^ aVisitor visitGtLlmSystemMessage: self
]
