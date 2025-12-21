Class {
	#name : #GtLFailureThreadMessage,
	#superclass : #Object,
	#instVars : [
		'failureText',
		'createdAt',
		'chat'
	],
	#category : #'Gt4LlmCore-UI'
}

{ #category : #'as yet unclassified' }
GtLFailureThreadMessage >> action [
	^ ''
]

{ #category : #accessing }
GtLFailureThreadMessage >> ancestor [
	^ self chat messages first
]

{ #category : #accessing }
GtLFailureThreadMessage >> annotations [
	^ #()
]

{ #category : #'as yet unclassified' }
GtLFailureThreadMessage >> arguments [
	^ {}
]

{ #category : #accessing }
GtLFailureThreadMessage >> chat [
	^ chat
]

{ #category : #accessing }
GtLFailureThreadMessage >> chat: anObject [
	chat := anObject
]

{ #category : #'as yet unclassified' }
GtLFailureThreadMessage >> contentJson [
	^ {} asDictionary
]

{ #category : #accessing }
GtLFailureThreadMessage >> contentSummary [
	^ self contentText lines ifEmpty: [ '' ] ifNotEmpty: #first
]

{ #category : #accessing }
GtLFailureThreadMessage >> contentText [
	^ self failureText ifNil: [ '' ]
]

{ #category : #accessing }
GtLFailureThreadMessage >> createdAt [
	^ createdAt
]

{ #category : #accessing }
GtLFailureThreadMessage >> createdAt: anObject [
	createdAt := anObject
]

{ #category : #ui }
GtLFailureThreadMessage >> elementClass [
	^ GtLChatMessageElement
]

{ #category : #accessing }
GtLFailureThreadMessage >> failureText [
	^ failureText
]

{ #category : #accessing }
GtLFailureThreadMessage >> failureText: anObject [
	failureText := anObject
]

{ #category : #ui }
GtLFailureThreadMessage >> gtContentFor: aView [
	<gtView>
	<gtLlmMessageView>
	^ aView explicit
		title: 'Content';
		priority: 1;
		stencil: [ GtLChatMessageElement new
				threadMessageViewModel: (GtLChatMessageViewModel new threadMessage: self) ]
]

{ #category : #testing }
GtLFailureThreadMessage >> hasResponse [
	^ true
]

{ #category : #accessing }
GtLFailureThreadMessage >> id [
	^ '3a876ca3-32ce-0d00-b7b2-b9390ae84159'
]

{ #category : #testing }
GtLFailureThreadMessage >> isAssistantRole [
	^ true
]

{ #category : #testing }
GtLFailureThreadMessage >> isFailure [
	^ true
]

{ #category : #accessing }
GtLFailureThreadMessage >> senderText [
	^  'Assistant'
]

{ #category : #accessing }
GtLFailureThreadMessage >> styler [
	^ nil
]

{ #category : #subscriptions }
GtLFailureThreadMessage >> unsubscribe: anObject [
	"do nothing"

	
]

{ #category : #subscriptions }
GtLFailureThreadMessage >> when: anEventSelector send: aMessageSelector to: anObject [
	"do nothing"

	
]
