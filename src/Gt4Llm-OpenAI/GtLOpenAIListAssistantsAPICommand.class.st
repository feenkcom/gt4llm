Class {
	#name : #GtLOpenAIListAssistantsAPICommand,
	#superclass : #GtLAPICommand,
	#category : #'Gt4Llm-OpenAI'
}

{ #category : #'as yet unclassified' }
GtLOpenAIListAssistantsAPICommand >> request [
	^ self client get: '/assistants'
]

{ #category : #'as yet unclassified' }
GtLOpenAIListAssistantsAPICommand >> serializationClass [
	^ GtLOpenAIAssistantsGroup
]
