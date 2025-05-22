Class {
	#name : #GtGeminiListModelsAPIClient,
	#superclass : #GtLlmEndpointClient,
	#category : #Gt4Gemini
}

{ #category : #'as yet unclassified' }
GtGeminiListModelsAPIClient >> request [
	^ self client get: '/models'
]

{ #category : #'as yet unclassified' }
GtGeminiListModelsAPIClient >> serializationClass [
	^ GtGeminiModelsGroup
]
