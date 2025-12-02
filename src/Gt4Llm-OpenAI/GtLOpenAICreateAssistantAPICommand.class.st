Class {
	#name : #GtLOpenAICreateAssistantAPICommand,
	#superclass : #GtLAPICommand,
	#instVars : [
		'assistant'
	],
	#category : #'Gt4Llm-OpenAI'
}

{ #category : #accessing }
GtLOpenAICreateAssistantAPICommand >> assistant [
	^ assistant
]

{ #category : #accessing }
GtLOpenAICreateAssistantAPICommand >> assistant: anObject [
	assistant := anObject
]

{ #category : #accessing }
GtLOpenAICreateAssistantAPICommand >> request [
	^ self client
		post: '/assistants'
		withEntity: self assistant serialize
]

{ #category : #accessing }
GtLOpenAICreateAssistantAPICommand >> serializationClass [
	^ GtLOpenAIAssistant
]
