Class {
	#name : #GtLOpenAICreateAssistantAPIClient,
	#superclass : #GtLlmEndpointClient,
	#instVars : [
		'assistant'
	],
	#category : #'Gt4Llm-OpenAI'
}

{ #category : #accessing }
GtLOpenAICreateAssistantAPIClient >> assistant [
	^ assistant
]

{ #category : #accessing }
GtLOpenAICreateAssistantAPIClient >> assistant: anObject [
	assistant := anObject
]

{ #category : #accessing }
GtLOpenAICreateAssistantAPIClient >> request [
	^ self client
		post: '/assistants'
		withEntity: self assistant serialize
]

{ #category : #accessing }
GtLOpenAICreateAssistantAPIClient >> serializationClass [
	^ GtLOpenAIAssistant
]
