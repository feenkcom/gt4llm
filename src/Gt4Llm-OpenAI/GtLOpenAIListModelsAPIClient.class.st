Class {
	#name : #GtLOpenAIListModelsAPIClient,
	#superclass : #GtLlmEndpointClient,
	#category : #'Gt4Llm-OpenAI'
}

{ #category : #accessing }
GtLOpenAIListModelsAPIClient >> request [
	^ self client get: '/models'
]

{ #category : #accessing }
GtLOpenAIListModelsAPIClient >> serializationClass [
	^ GtLOpenAIModelsGroup
]
