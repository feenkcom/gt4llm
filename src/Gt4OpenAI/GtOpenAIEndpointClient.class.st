Class {
	#name : #GtOpenAIEndpointClient,
	#superclass : #Object,
	#instVars : [
		'client'
	],
	#category : #'Gt4OpenAI-Client'
}

{ #category : #accessing }
GtOpenAIEndpointClient >> client [
	^ client
]

{ #category : #accessing }
GtOpenAIEndpointClient >> client: anObject [
	client := anObject
]

{ #category : #accessing }
GtOpenAIEndpointClient >> perform [
	| aResult |
	aResult := self request.

	^ (self serializationClass from: aResult) client: self client
]

{ #category : #accessing }
GtOpenAIEndpointClient >> request [
	^ self subclassResponsibility
]

{ #category : #accessing }
GtOpenAIEndpointClient >> serializationClass [
	^ self subclassResponsibility
]
