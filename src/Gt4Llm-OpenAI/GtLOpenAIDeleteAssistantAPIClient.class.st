Class {
	#name : #GtLOpenAIDeleteAssistantAPIClient,
	#superclass : #GtLAPICommand,
	#instVars : [
		'assistant'
	],
	#category : #'Gt4Llm-OpenAI'
}

{ #category : #accessing }
GtLOpenAIDeleteAssistantAPIClient >> assistant [
	^ assistant
]

{ #category : #accessing }
GtLOpenAIDeleteAssistantAPIClient >> assistant: anObject [
	assistant := anObject
]

{ #category : #accessing }
GtLOpenAIDeleteAssistantAPIClient >> request [
	^ self client
		delete: 'assistants/', assistant
]

{ #category : #accessing }
GtLOpenAIDeleteAssistantAPIClient >> serializationClass [
	^ GtLOpenAIDeletion
]
