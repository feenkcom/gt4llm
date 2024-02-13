Class {
	#name : #Gt4OpenAIDeleteAssistantAPIClient,
	#superclass : #Gt4OpenAIEndpointClient,
	#instVars : [
		'assistant'
	],
	#category : #'Gt4OpenAI-Client'
}

{ #category : #accessing }
Gt4OpenAIDeleteAssistantAPIClient >> assistant [
	^ assistant
]

{ #category : #accessing }
Gt4OpenAIDeleteAssistantAPIClient >> assistant: anObject [
	assistant := anObject
]

{ #category : #accessing }
Gt4OpenAIDeleteAssistantAPIClient >> request [
	^ self client
		delete: 'assistants/', assistant
]

{ #category : #accessing }
Gt4OpenAIDeleteAssistantAPIClient >> serializationClass [
	^ Gt4OpenAIDeletion
]
