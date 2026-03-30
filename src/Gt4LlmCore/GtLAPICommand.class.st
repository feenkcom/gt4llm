Class {
	#name : #GtLAPICommand,
	#superclass : #Object,
	#instVars : [
		'client'
	],
	#category : 'Gt4LlmCore-Core'
}

{ #category : #accessing }
GtLAPICommand >> client [
	^ client
]

{ #category : #accessing }
GtLAPICommand >> client: anObject [
	client := anObject
]

{ #category : #accessing }
GtLAPICommand >> perform [
	| requestResponse result |
	requestResponse := self request.
	result := requestResponse result.

	^ (self serializationClass from: result)
		client: self client;
		requestResponse: requestResponse
]

{ #category : #accessing }
GtLAPICommand >> request [
	^ self subclassResponsibility
]

{ #category : #accessing }
GtLAPICommand >> serializationClass [
	^ self subclassResponsibility
]
