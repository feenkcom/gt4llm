Class {
	#name : #GtLUserMessage,
	#superclass : #GtLChatMessage,
	#category : #Gt4LlmCore
}

{ #category : #accessing }
GtLUserMessage class >> defaultRole [
	^ 'user'
]

{ #category : #accessing }
GtLUserMessage class >> leJsonV4Name [

	^ #gtLUserMessage
]

{ #category : #visiting }
GtLUserMessage >> acceptVisitor: aVisitor [

	^ aVisitor visitGtLlmUserMessage: self
]
