Class {
	#name : #Gt4OpenAIThreadRunFuture,
	#superclass : #Object,
	#traits : 'TAsyncFuture',
	#classTraits : 'TAsyncFuture classTrait',
	#instVars : [
		'chat',
		'delay'
	],
	#category : #'Gt4OpenAI-Futures'
}

{ #category : #accessing }
Gt4OpenAIThreadRunFuture >> chat [
	^ chat
]

{ #category : #accessing }
Gt4OpenAIThreadRunFuture >> chat: anObject [
	chat := anObject
]

{ #category : #accessing }
Gt4OpenAIThreadRunFuture >> defaultDelay [
	^ 5 seconds
]

{ #category : #accessing }
Gt4OpenAIThreadRunFuture >> initialize [
	delay := self defaultDelay
]

{ #category : #accessing }
Gt4OpenAIThreadRunFuture >> poll: anAsynchronousContext [
	| aValue |
	self
		assert: [ chat lastRun isDone not ]
		description: [ 'Value already polled' ].

	aValue := chat getRun.

	aValue isDone
		ifTrue: [ ^ AsyncPoll ready: aValue ]
		ifFalse: [ TaskAtQueue default
				schedule: [
					anAsynchronousContext waker wakeUp ]
				at: DateAndTime now + delay
				entryIdentifier: self.
			^ AsyncPoll pending ]
]
