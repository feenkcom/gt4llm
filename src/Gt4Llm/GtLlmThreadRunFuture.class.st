Class {
	#name : #GtLlmThreadRunFuture,
	#superclass : #Object,
	#traits : 'TAsyncFuture',
	#classTraits : 'TAsyncFuture classTrait',
	#instVars : [
		'chat',
		'delay'
	],
	#category : #Gt4Llm
}

{ #category : #accessing }
GtLlmThreadRunFuture >> chat [
	^ chat
]

{ #category : #accessing }
GtLlmThreadRunFuture >> chat: anObject [
	chat := anObject
]

{ #category : #accessing }
GtLlmThreadRunFuture >> defaultDelay [
	^ 5 seconds
]

{ #category : #accessing }
GtLlmThreadRunFuture >> initialize [
	delay := self defaultDelay
]

{ #category : #accessing }
GtLlmThreadRunFuture >> poll: anAsynchronousContext [
	| aValue |
	self
		assert: [ chat lastRun isDone not ]
		description: [ 'Value already polled' ].

	aValue := chat getRun.

	aValue isDone
		ifTrue: [ ^ AsyncPoll ready: aValue ]
		ifFalse: [ TaskAtQueue default
				schedule: [ anAsynchronousContext waker wakeUp ]
				at: DateAndTime now + delay
				entryIdentifier: self.
			^ AsyncPoll pending ]
]
