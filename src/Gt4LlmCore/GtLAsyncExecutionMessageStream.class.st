Class {
	#name : #GtLAsyncExecutionMessageStream,
	#superclass : #Object,
	#traits : 'TAsyncStream',
	#classTraits : 'TAsyncStream classTrait',
	#instVars : [
		'replyMessage',
		'executionMessages',
		'waker'
	],
	#category : #'Gt4LlmCore-Support'
}

{ #category : #'instance creation' }
GtLAsyncExecutionMessageStream class >> forReplyMessage: aReplyMessage [
	^ self new replyMessage: aReplyMessage
]

{ #category : #'private - event handling' }
GtLAsyncExecutionMessageStream >> onMessageExecutionMessagesChanged: anAnnouncement [
	"Execution messages are always only added."

	executionMessages
		lock: [ :theExecutionMessages | 
			anAnnouncement addedExecutionMessages
				do: [ :eachMessage | theExecutionMessages addLast: eachMessage ].
			waker wakeUp ]
]

{ #category : #'api - stream' }
GtLAsyncExecutionMessageStream >> pollNext: anAsynchronousContext [
	"Attempt to pull out the next value of this stream, registering the current task for wakeup if the value is not yet available, and returning None if the stream is exhausted.
	There are several possible return values, each indicating a distinct stream state:
	 - Poll::Pending means that this stream's next value is not ready yet. Implementations will ensure that the current task will be notified when the next value may be ready.
	 - Poll::Ready(Some(val)) means that the stream has successfully produced a value, val, and may produce further values on subsequent poll_next calls.
	 - Poll::Ready(None) means that the stream has terminated, and poll_next should not be invoked again."

	<return: #AsyncPoll>
	^ executionMessages
		lock: [ :theMessages | 
			theMessages
				ifEmpty: [ 
					waker register: anAsynchronousContext waker.
					AsyncPoll indefinitelyPending ]
				ifNotEmpty: [ 
					AsyncPoll ready: (AsyncOptionalValue some: theMessages removeFirst) ] ]
]

{ #category : #'api - stream copy' }
GtLAsyncExecutionMessageStream >> postSimilarCopy [
	"Is called by similarCopy. self is a shallow copy, implementors should set the fields as necessary to complete the similar copy"

	self replyMessage: replyMessage
]

{ #category : #initialization }
GtLAsyncExecutionMessageStream >> replyMessage: aReplyMessage [
	aReplyMessage executionMessagesLock: [ :aList |
		executionMessages := AsyncMutex for: (LinkedList withAll: aList).
		waker := AsyncFutureExecutionAtomicWaker new.
		
		replyMessage := aReplyMessage.
		replyMessage announcer weak
			when: GtLMessageExecutionMessagesChanged
			send: #onMessageExecutionMessagesChanged:
			to: self ]
]
