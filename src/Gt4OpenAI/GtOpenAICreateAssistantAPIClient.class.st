Class {
	#name : #GtOpenAICreateAssistantAPIClient,
	#superclass : #GtOpenAIEndpointClient,
	#instVars : [
		'assistant'
	],
	#category : #'Gt4OpenAI-Client'
}

{ #category : #accessing }
GtOpenAICreateAssistantAPIClient >> assistant [
	^ assistant
]

{ #category : #accessing }
GtOpenAICreateAssistantAPIClient >> assistant: anObject [
	assistant := anObject
]

{ #category : #accessing }
GtOpenAICreateAssistantAPIClient >> request [
	^ self client
		post: '/assistants'
		withEntity: self assistant serialize
]

{ #category : #accessing }
GtOpenAICreateAssistantAPIClient >> serializationClass [
	^ GtOpenAIAssistant
]
