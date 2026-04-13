Class {
	#name : #GtLOllamaEndpointClient,
	#superclass : #Object,
	#instVars : [
		'client'
	],
	#category : #'Gt4Llm-Ollama-Client'
}

{ #category : #accessing }
GtLOllamaEndpointClient >> client [
	^ client
]

{ #category : #accessing }
GtLOllamaEndpointClient >> client: anObject [
	client := anObject
]

{ #category : #api }
GtLOllamaEndpointClient >> perform [
	| result |
	result := self request.
	^ (self serializationClass from: result result)
		client: self client;
		requestResponse: result;
		yourself
]

{ #category : #api }
GtLOllamaEndpointClient >> request [
	^ self subclassResponsibility
]

{ #category : #api }
GtLOllamaEndpointClient >> serializationClass [
	^ self subclassResponsibility
]
