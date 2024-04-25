Class {
	#name : #GtOpenAIDeleteAssistantAPIClient,
	#superclass : #GtLlmEndpointClient,
	#instVars : [
		'assistant'
	],
	#category : #'Gt4OpenAI-Client'
}

{ #category : #accessing }
GtOpenAIDeleteAssistantAPIClient >> assistant [
	^ assistant
]

{ #category : #accessing }
GtOpenAIDeleteAssistantAPIClient >> assistant: anObject [
	assistant := anObject
]

{ #category : #accessing }
GtOpenAIDeleteAssistantAPIClient >> request [
	^ self client
		delete: 'assistants/', assistant
]

{ #category : #accessing }
GtOpenAIDeleteAssistantAPIClient >> serializationClass [
	^ GtOpenAIDeletion
]
