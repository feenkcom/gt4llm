Class {
	#name : #GtLFailureMessage,
	#superclass : #GtLBasicMessage,
	#instVars : [
		'failureText',
		'createdAt',
		'chat'
	],
	#category : 'Gt4LlmCore-Core'
}

{ #category : #'as yet unclassified' }
GtLFailureMessage >> action [
	^ ''
]

{ #category : #accessing }
GtLFailureMessage >> ancestor [
	^ self chat messages first
]

{ #category : #accessing }
GtLFailureMessage >> annotations [
	^ #()
]

{ #category : #'as yet unclassified' }
GtLFailureMessage >> arguments [
	^ {}
]

{ #category : #accessing }
GtLFailureMessage >> chat [
	^ chat
]

{ #category : #accessing }
GtLFailureMessage >> chat: anObject [
	chat := anObject
]

{ #category : #'as yet unclassified' }
GtLFailureMessage >> contentJson [
	^ {} asDictionary
]

{ #category : #accessing }
GtLFailureMessage >> contentSummary [
	^ self contentText lines ifEmpty: [ '' ] ifNotEmpty: #first
]

{ #category : #accessing }
GtLFailureMessage >> contentText [
	^ self failureText ifNil: [ '' ]
]

{ #category : #accessing }
GtLFailureMessage >> createdAt [
	^ createdAt
]

{ #category : #accessing }
GtLFailureMessage >> createdAt: anObject [
	createdAt := anObject
]

{ #category : #accessing }
GtLFailureMessage >> failureText [
	^ failureText
]

{ #category : #accessing }
GtLFailureMessage >> failureText: anObject [
	failureText := anObject
]

{ #category : #ui }
GtLFailureMessage >> gtContentFor: aView [
	<gtView>
	<gtLlmView>
	^ aView explicit
		title: 'Content';
		priority: 1;
		stencil: [ GtLChatMessageElement new
				threadMessageViewModel: (GtLMessageViewModel new threadMessage: self) ]
]

{ #category : #testing }
GtLFailureMessage >> hasResponse [
	^ true
]

{ #category : #accessing }
GtLFailureMessage >> id [
	^ '3a876ca3-32ce-0d00-b7b2-b9390ae84159'
]

{ #category : #testing }
GtLFailureMessage >> isAssistantRole [
	^ true
]

{ #category : #testing }
GtLFailureMessage >> isFailure [
	^ true
]

{ #category : #accessing }
GtLFailureMessage >> senderText [
	^  'Assistant'
]

{ #category : #accessing }
GtLFailureMessage >> styler [
	^ nil
]

{ #category : #subscriptions }
GtLFailureMessage >> unsubscribe: anObject [
	"do nothing"

	
]

{ #category : #'api - converting' }
GtLFailureMessage >> viewModelClass [
	^ GtLFailureMessageViewModel
]

{ #category : #subscriptions }
GtLFailureMessage >> when: anEventSelector send: aMessageSelector to: anObject [
	"do nothing"

	
]
