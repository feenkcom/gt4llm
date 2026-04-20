Class {
	#name : #GtLOllamaEndpointCommand,
	#superclass : #Object,
	#instVars : [
		'client'
	],
	#category : 'Gt4Llm-Ollama-Client'
}

{ #category : #accessing }
GtLOllamaEndpointCommand >> client [
	^ client
]

{ #category : #accessing }
GtLOllamaEndpointCommand >> client: anObject [
	client := anObject
]

{ #category : #api }
GtLOllamaEndpointCommand >> perform [
	| result |
	result := self request.
	^ (self serializationClass from: result result)
		client: self client;
		requestResponse: result;
		yourself
]

{ #category : #api }
GtLOllamaEndpointCommand >> request [
	^ self subclassResponsibility
]

{ #category : #api }
GtLOllamaEndpointCommand >> serializationClass [
	^ self subclassResponsibility
]
