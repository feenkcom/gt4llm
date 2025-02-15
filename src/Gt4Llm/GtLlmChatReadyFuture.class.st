Class {
	#name : #GtLlmChatReadyFuture,
	#superclass : #Object,
	#traits : 'TAsyncFuture',
	#classTraits : 'TAsyncFuture classTrait',
	#instVars : [
		'chat',
		'delay'
	],
	#category : #'Gt4Llm-Futures'
}

{ #category : #accessing }
GtLlmChatReadyFuture >> chat [
	^ chat
]

{ #category : #accessing }
GtLlmChatReadyFuture >> chat: anObject [
	chat := anObject
]

{ #category : #accessing }
GtLlmChatReadyFuture >> defaultDelay [
	^ 100 milliseconds
]

{ #category : #accessing }
GtLlmChatReadyFuture >> delay [
	^ delay
]

{ #category : #accessing }
GtLlmChatReadyFuture >> delay: anObject [
	delay := anObject
]

{ #category : #accessing }
GtLlmChatReadyFuture >> initialize [
	super initialize.
	
	delay := self defaultDelay
]

{ #category : #accessing }
GtLlmChatReadyFuture >> poll: aContext [
	| status |
	status := chat status.

	(status isDone
		and: [ chat messages last isAssistantRole and: [ chat messages last isReady ] ])
		ifTrue: [ ^ AsyncPoll ready: true ]
		ifFalse: [ TaskAtQueue default
				schedule: [ aContext waker wakeUp ]
				at: DateAndTime now + delay
				entryIdentifier: self.
			^ AsyncPoll pending ]
]
