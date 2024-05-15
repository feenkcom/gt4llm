Class {
	#name : #GtOpenAIAssistantChatReadyFuture,
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
GtOpenAIAssistantChatReadyFuture >> chat [
	^ chat
]

{ #category : #accessing }
GtOpenAIAssistantChatReadyFuture >> chat: anObject [
	chat := anObject
]

{ #category : #accessing }
GtOpenAIAssistantChatReadyFuture >> defaultDelay [
	^ 100 milliseconds
]

{ #category : #accessing }
GtOpenAIAssistantChatReadyFuture >> delay [
	^ delay
]

{ #category : #accessing }
GtOpenAIAssistantChatReadyFuture >> delay: anObject [
	delay := anObject
]

{ #category : #accessing }
GtOpenAIAssistantChatReadyFuture >> initialize [
	super initialize.
	
	delay := self defaultDelay
]

{ #category : #accessing }
GtOpenAIAssistantChatReadyFuture >> poll: aContext [
	| status |
	status := chat status.

	status isDone
		ifTrue: [ ^ AsyncPoll ready: true ]
		ifFalse: [ TaskAtQueue default
				schedule: [ aContext waker wakeUp ]
				at: DateAndTime now + delay
				entryIdentifier: self.
			^ AsyncPoll pending ]
]
