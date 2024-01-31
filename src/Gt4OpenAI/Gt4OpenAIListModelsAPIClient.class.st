Class {
	#name : #Gt4OpenAIListModelsAPIClient,
	#superclass : #Gt4OpenAIEndpointClient,
	#category : #'Gt4OpenAI-Client'
}

{ #category : #accessing }
Gt4OpenAIListModelsAPIClient >> request [
	^ self client get: '/models'
]

{ #category : #accessing }
Gt4OpenAIListModelsAPIClient >> serializationClass [
	^ Gt4OpenAIModelsGroup
]
