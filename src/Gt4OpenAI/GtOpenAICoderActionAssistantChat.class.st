Class {
	#name : #GtOpenAICoderActionAssistantChat,
	#superclass : #GtOpenAIActionAssistantChat,
	#category : #'Gt4OpenAI-Tutor'
}

{ #category : #accessing }
GtOpenAICoderActionAssistantChat >> instructions [
	^ self assistant instructions
]

{ #category : #accessing }
GtOpenAICoderActionAssistantChat >> method [
	^ self pipeline instance method
]

{ #category : #accessing }
GtOpenAICoderActionAssistantChat >> method: aMethod [
	self pipeline instance method: aMethod
]

{ #category : #accessing }
GtOpenAICoderActionAssistantChat >> pipeline: aPipeline [
	super pipeline: aPipeline.
	aPipeline instance chat: self.
]

{ #category : #accessing }
GtOpenAICoderActionAssistantChat >> printOn: aStream [
	super printOn: aStream.

	aStream nextPut: $(.
	self method printOn: aStream.
	aStream nextPut: $)
]
