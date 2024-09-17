Class {
	#name : #GtLlmNewActionThreadMessage,
	#superclass : #GtLlmNewThreadMessage,
	#instVars : [
		'currentAction'
	],
	#category : #'Gt4OpenAI-Widgets'
}

{ #category : #accessing }
GtLlmNewActionThreadMessage >> currentAction [
	^ currentAction
]

{ #category : #accessing }
GtLlmNewActionThreadMessage >> currentAction: anObject [
	currentAction := anObject
]

{ #category : #'as yet unclassified' }
GtLlmNewActionThreadMessage >> sendMessage [
	| aMessage |
	currentAction ifNil: [ ^ self ].

	aMessage := currentAction format format: {contents}.

	self contents: '' requester: nil.

	(assistantChat whenReadyFuture then: [ assistantChat sendMessage: aMessage ])
		await
]
