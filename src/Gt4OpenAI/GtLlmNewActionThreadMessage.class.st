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

	aMessage := GtLlmCompositeMessage new
			chat: assistantChat;
			addString: (assistantChat messageFromString: (currentAction format format: {contents})).


	files do: [ :aFile | aMessage addFile: aFile ].

	self contents: '' requester: nil.

	(assistantChat whenReadyFuture
		then: [ assistantChat sendAssistantMessage: aMessage ]) await
]
