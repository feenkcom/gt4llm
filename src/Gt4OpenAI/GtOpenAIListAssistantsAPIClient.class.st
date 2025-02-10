Class {
	#name : #GtOpenAIListAssistantsAPIClient,
	#superclass : #GtLlmEndpointClient,
	#category : #'Gt4OpenAI-Client'
}

{ #category : #'as yet unclassified' }
GtOpenAIListAssistantsAPIClient >> request [
	^ self client get: '/assistants'
]

{ #category : #'as yet unclassified' }
GtOpenAIListAssistantsAPIClient >> serializationClass [
	^ GtOpenAIAssistantsGroup
]
