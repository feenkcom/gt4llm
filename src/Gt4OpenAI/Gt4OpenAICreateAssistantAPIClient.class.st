Class {
	#name : #Gt4OpenAICreateAssistantAPIClient,
	#superclass : #Gt4OpenAIEndpointClient,
	#instVars : [
		'assistant'
	],
	#category : #'Gt4OpenAI-Client'
}

{ #category : #accessing }
Gt4OpenAICreateAssistantAPIClient >> assistant [
	^ assistant
]

{ #category : #accessing }
Gt4OpenAICreateAssistantAPIClient >> assistant: anObject [
	assistant := anObject
]

{ #category : #accessing }
Gt4OpenAICreateAssistantAPIClient >> request [
	^ self client
		post: '/assistants'
		withEntity: self assistant serialize
]

{ #category : #accessing }
Gt4OpenAICreateAssistantAPIClient >> serializationClass [
	^ Gt4OpenAIAssistant
]
