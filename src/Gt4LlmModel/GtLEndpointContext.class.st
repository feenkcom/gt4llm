Class {
	#name : #GtLEndpointContext,
	#superclass : #Object,
	#instVars : [
		'provider',
		'model',
		'chat',
		'response',
		'command'
	],
	#category : #'Gt4LlmModel-Model'
}

{ #category : #accessing }
GtLEndpointContext >> chat [
	^ chat
]

{ #category : #accessing }
GtLEndpointContext >> chat: anObject [
	chat := anObject
]

{ #category : #accessing }
GtLEndpointContext >> client [
	^ model client
]

{ #category : #accessing }
GtLEndpointContext >> command [
	^ command
]

{ #category : #accessing }
GtLEndpointContext >> command: anObject [
	command := anObject
]

{ #category : #accessing }
GtLEndpointContext >> model [
	^ model
]

{ #category : #accessing }
GtLEndpointContext >> model: anObject [
	model := anObject
]

{ #category : #accessing }
GtLEndpointContext >> provider [
	^ provider
]

{ #category : #accessing }
GtLEndpointContext >> provider: anObject [
	provider := anObject
]

{ #category : #accessing }
GtLEndpointContext >> response [
	^ response
]

{ #category : #accessing }
GtLEndpointContext >> response: anObject [
	response := anObject
]
