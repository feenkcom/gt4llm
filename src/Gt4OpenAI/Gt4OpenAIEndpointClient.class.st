Class {
	#name : #Gt4OpenAIEndpointClient,
	#superclass : #Object,
	#instVars : [
		'client'
	],
	#category : #'Gt4OpenAI-Client'
}

{ #category : #accessing }
Gt4OpenAIEndpointClient >> client [
	^ client
]

{ #category : #accessing }
Gt4OpenAIEndpointClient >> client: anObject [
	client := anObject
]

{ #category : #accessing }
Gt4OpenAIEndpointClient >> perform [
	| aResult |
	aResult := self request.

	^ (self serializationClass from: aResult) client: self client
]

{ #category : #accessing }
Gt4OpenAIEndpointClient >> request [
	^ self subclassResponsibility
]

{ #category : #accessing }
Gt4OpenAIEndpointClient >> serializationClass [
	^ self subclassResponsibility
]
