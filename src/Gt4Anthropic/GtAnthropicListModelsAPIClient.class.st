Class {
	#name : #GtAnthropicListModelsAPIClient,
	#superclass : #GtLlmEndpointClient,
	#category : #Gt4Anthropic
}

{ #category : #'as yet unclassified' }
GtAnthropicListModelsAPIClient >> request [
	^ self client get: '/models'
]

{ #category : #'as yet unclassified' }
GtAnthropicListModelsAPIClient >> serializationClass [
	^ GtAnthropicModelsGroup
]
