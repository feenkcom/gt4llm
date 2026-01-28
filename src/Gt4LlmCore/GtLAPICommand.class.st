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
	| aResult |
	aResult := self request.

	^ (self serializationClass from: aResult) client: self client
]

{ #category : #accessing }
GtLAPICommand >> request [
	^ self subclassResponsibility
]

{ #category : #accessing }
GtLAPICommand >> serializationClass [
	^ self subclassResponsibility
]
