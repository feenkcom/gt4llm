Class {
	#name : #GtOpenAIThreadRunFuture,
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
GtOpenAIThreadRunFuture >> chat [
	^ chat
]

{ #category : #accessing }
GtOpenAIThreadRunFuture >> chat: anObject [
	chat := anObject
]

{ #category : #accessing }
GtOpenAIThreadRunFuture >> defaultDelay [
	^ 5 seconds
]

{ #category : #accessing }
GtOpenAIThreadRunFuture >> initialize [
	delay := self defaultDelay
]

{ #category : #accessing }
GtOpenAIThreadRunFuture >> poll: anAsynchronousContext [
	| aValue |
	self
		assert: [ chat lastRun isDone not ]
		description: [ 'Value already polled' ].

	aValue := chat getRun.

	(aValue isDone and: [ chat messages first hasResponse ])
		ifTrue: [ ^ AsyncPoll ready: aValue ]
		ifFalse: [ TaskAtQueue default
				schedule: [ anAsynchronousContext waker wakeUp ]
				at: DateAndTime now + delay
				entryIdentifier: self.
			^ AsyncPoll pending ]
]
