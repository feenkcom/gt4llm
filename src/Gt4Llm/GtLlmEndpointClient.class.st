Class {
	#name : #GtLlmEndpointClient,
	#superclass : #Object,
	#instVars : [
		'client'
	],
	#category : #'Gt4Llm-Client'
}

{ #category : #accessing }
GtLlmEndpointClient >> client [
	^ client
]

{ #category : #accessing }
GtLlmEndpointClient >> client: anObject [
	client := anObject
]

{ #category : #accessing }
GtLlmEndpointClient >> perform [
	| aResult |
	aResult := self request.

	^ (self serializationClass from: aResult) client: self client
]

{ #category : #accessing }
GtLlmEndpointClient >> request [
	^ self subclassResponsibility
]

{ #category : #accessing }
GtLlmEndpointClient >> serializationClass [
	^ GtOllamaModelsGroup
]
