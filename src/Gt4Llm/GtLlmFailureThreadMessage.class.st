Class {
	#name : #GtLlmFailureThreadMessage,
	#superclass : #Object,
	#traits : 'TGtLlmThreadMessage',
	#classTraits : 'TGtLlmThreadMessage classTrait',
	#instVars : [
		'failureText',
		'createdAt',
		'chat'
	],
	#category : #'Gt4Llm-Widgets'
}

{ #category : #'as yet unclassified' }
GtLlmFailureThreadMessage >> action [
	^ ''
]

{ #category : #accessing }
GtLlmFailureThreadMessage >> ancestor [
	^ self chat messages first
]

{ #category : #accessing }
GtLlmFailureThreadMessage >> annotations [
	^ #()
]

{ #category : #accessing }
GtLlmFailureThreadMessage >> chat [
	^ chat
]

{ #category : #accessing }
GtLlmFailureThreadMessage >> chat: anObject [
	chat := anObject
]

{ #category : #accessing }
GtLlmFailureThreadMessage >> contentSummary [
	^ self contentText lines ifEmpty: [ '' ] ifNotEmpty: #first
]

{ #category : #accessing }
GtLlmFailureThreadMessage >> contentText [
	^ self failureText ifNil: [ '' ]
]

{ #category : #accessing }
GtLlmFailureThreadMessage >> createdAt [
	^ createdAt
]

{ #category : #accessing }
GtLlmFailureThreadMessage >> createdAt: anObject [
	createdAt := anObject
]

{ #category : #accessing }
GtLlmFailureThreadMessage >> elementClass [
	^ GtLlmThreadMessageElement
]

{ #category : #accessing }
GtLlmFailureThreadMessage >> failureText [
	^ failureText
]

{ #category : #accessing }
GtLlmFailureThreadMessage >> failureText: anObject [
	failureText := anObject
]

{ #category : #accessing }
GtLlmFailureThreadMessage >> gtContentFor: aView [
	<gtView>
	<gtLlmMessageView>
	^ aView explicit
		title: 'Content';
		priority: 1;
		stencil: [ GtLlmThreadMessageElement new
				threadMessageViewModel: (GtLlmThreadMessageViewModel new threadMessage: self) ]
]

{ #category : #testing }
GtLlmFailureThreadMessage >> hasResponse [
	^ true
]

{ #category : #accessing }
GtLlmFailureThreadMessage >> id [
	^ '3a876ca3-32ce-0d00-b7b2-b9390ae84159'
]

{ #category : #testing }
GtLlmFailureThreadMessage >> isAssistantRole [
	^ true
]

{ #category : #accessing }
GtLlmFailureThreadMessage >> isFailure [
	^ true
]

{ #category : #accessing }
GtLlmFailureThreadMessage >> senderText [
	^  'Assistant'
]

{ #category : #accessing }
GtLlmFailureThreadMessage >> styler [
	^ nil
]

{ #category : #subscriptions }
GtLlmFailureThreadMessage >> unsubscribe: anObject [
	"do nothing"

	
]

{ #category : #subscriptions }
GtLlmFailureThreadMessage >> when: anEventSelector send: aMessageSelector to: anObject [
	"do nothing"

	
]
