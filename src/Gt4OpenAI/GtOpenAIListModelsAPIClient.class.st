Class {
	#name : #GtOpenAIListModelsAPIClient,
	#superclass : #GtLlmEndpointClient,
	#category : #Gt4OpenAI
}

{ #category : #accessing }
GtOpenAIListModelsAPIClient >> request [
	^ self client get: '/models'
]

{ #category : #accessing }
GtOpenAIListModelsAPIClient >> serializationClass [
	^ GtOpenAIModelsGroup
]
