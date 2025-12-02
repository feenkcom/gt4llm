Class {
	#name : #GtLOpenAIDeleteAssistantAPICommand,
	#superclass : #GtLAPICommand,
	#instVars : [
		'assistant'
	],
	#category : #'Gt4Llm-OpenAI'
}

{ #category : #accessing }
GtLOpenAIDeleteAssistantAPICommand >> assistant [
	^ assistant
]

{ #category : #accessing }
GtLOpenAIDeleteAssistantAPICommand >> assistant: anObject [
	assistant := anObject
]

{ #category : #accessing }
GtLOpenAIDeleteAssistantAPICommand >> request [
	^ self client
		delete: 'assistants/', assistant
]

{ #category : #accessing }
GtLOpenAIDeleteAssistantAPICommand >> serializationClass [
	^ GtLOpenAIDeletion
]
