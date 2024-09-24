Class {
	#name : #GtOpenAIViewActionAssistantChat,
	#superclass : #GtOpenAIActionAssistantChat,
	#category : #'Gt4OpenAI-Tutor'
}

{ #category : #accessing }
GtOpenAIViewActionAssistantChat >> instructions [
	^ self assistant instructions
]

{ #category : #'as yet unclassified' }
GtOpenAIViewActionAssistantChat >> messageClass [
	^ GtOpenAIViewActionThreadMessage
]

{ #category : #accessing }
GtOpenAIViewActionAssistantChat >> object: aMethod [
	self pipeline instance object: aMethod
]

{ #category : #accessing }
GtOpenAIViewActionAssistantChat >> pipeline: aPipeline [
	super pipeline: aPipeline.
	aPipeline instance chat: self.
]
