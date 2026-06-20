Class {
	#name : #GtOpenAISseConsumerFuture,
	#superclass : #Object,
	#traits : 'TAsyncFuture',
	#classTraits : 'TAsyncFuture classTrait',
	#instVars : [
		'stream',
		'delay'
	],
	#category : #'Gt4OpenAI-GToolkit-Sse'
}

{ #category : #'as yet unclassified' }
GtOpenAISseConsumerFuture >> defaultDelay [
	^ 50 milliseconds
]

{ #category : #'as yet unclassified' }
GtOpenAISseConsumerFuture >> initialize [
	super initialize.
	
	delay := self defaultDelay
]

{ #category : #'api - future' }
GtOpenAISseConsumerFuture >> poll: anAsynchronousContext [
	<return: #AsyncPoll>
	self stream isAtEnd ifTrue: [ ^ AsyncPoll ready: self stream ].

	[ self stream isReadyForMore ]
		whileTrue: [ self stream addEvent: self stream nextEvent ].

	TaskAtQueue default
		schedule: [ anAsynchronousContext waker wakeUp ]
		at: DateAndTime now + delay
		entryIdentifier: self.

	^ AsyncPoll pending
]

{ #category : #accessing }
GtOpenAISseConsumerFuture >> stream [
	^ stream
]

{ #category : #accessing }
GtOpenAISseConsumerFuture >> stream: anObject [
	stream := anObject
]
