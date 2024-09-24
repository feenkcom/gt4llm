Class {
	#name : #GtOpenAIBlogpostAssistantChat,
	#superclass : #GtOpenAIActionAssistantChat,
	#category : #'Gt4OpenAI-Tutor'
}

{ #category : #'as yet unclassified' }
GtOpenAIBlogpostAssistantChat >> messageClass [
	^ GtOpenAIStepThreadMessage
]
