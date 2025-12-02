Class {
	#name : #GtLOpenAIListAssistantsAPIClient,
	#superclass : #GtLAPICommand,
	#category : #'Gt4Llm-OpenAI'
}

{ #category : #'as yet unclassified' }
GtLOpenAIListAssistantsAPIClient >> request [
	^ self client get: '/assistants'
]

{ #category : #'as yet unclassified' }
GtLOpenAIListAssistantsAPIClient >> serializationClass [
	^ GtLOpenAIAssistantsGroup
]
