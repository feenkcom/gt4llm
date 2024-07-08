Class {
	#name : #GtOpenAIFailureThreadMessage,
	#superclass : #Object,
	#traits : 'TGtLlmThreadMessage',
	#classTraits : 'TGtLlmThreadMessage classTrait',
	#instVars : [
		'failureText',
		'createdAt'
	],
	#category : #'Gt4OpenAI-Widgets'
}

{ #category : #accessing }
GtOpenAIFailureThreadMessage >> annotations [
	^ #()
]

{ #category : #accessing }
GtOpenAIFailureThreadMessage >> contentText [
	^ self failureText ifNil: [ '' ]
]

{ #category : #accessing }
GtOpenAIFailureThreadMessage >> createdAt [
	^ createdAt
]

{ #category : #accessing }
GtOpenAIFailureThreadMessage >> createdAt: anObject [
	createdAt := anObject
]

{ #category : #accessing }
GtOpenAIFailureThreadMessage >> elementClass [
	^ GtLlmThreadMessageElement
]

{ #category : #accessing }
GtOpenAIFailureThreadMessage >> failureText [
	^ failureText
]

{ #category : #accessing }
GtOpenAIFailureThreadMessage >> failureText: anObject [
	failureText := anObject
]

{ #category : #accessing }
GtOpenAIFailureThreadMessage >> gtContentFor: aView [
	<gtView>
	<gtLlmMessageView>
	^ aView explicit
		title: 'Content';
		priority: 1;
		stencil: [ GtLlmThreadMessageElement new
				threadMessageViewModel: (GtLlmThreadMessageViewModel new threadMessage: self) ]
]

{ #category : #testing }
GtOpenAIFailureThreadMessage >> hasResponse [
	^ true
]

{ #category : #accessing }
GtOpenAIFailureThreadMessage >> id [
	^ '3a876ca3-32ce-0d00-b7b2-b9390ae84159'
]

{ #category : #testing }
GtOpenAIFailureThreadMessage >> isAssistantRole [
	^ true
]

{ #category : #accessing }
GtOpenAIFailureThreadMessage >> isFailure [
	^ true
]

{ #category : #accessing }
GtOpenAIFailureThreadMessage >> styler [
	^ nil
]

{ #category : #subscriptions }
GtOpenAIFailureThreadMessage >> unsubscribe: anObject [
	"do nothing"

	
]

{ #category : #subscriptions }
GtOpenAIFailureThreadMessage >> when: anEventSelector send: aMessageSelector to: anObject [
	"do nothing"

	
]
