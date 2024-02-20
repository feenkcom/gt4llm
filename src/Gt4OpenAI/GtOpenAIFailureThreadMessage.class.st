Class {
	#name : #GtOpenAIFailureThreadMessage,
	#superclass : #Object,
	#instVars : [
		'failureText'
	],
	#category : #'Gt4OpenAI-Widgets'
}

{ #category : #accessing }
GtOpenAIFailureThreadMessage >> annotations [
	^ #()
]

{ #category : #accessing }
GtOpenAIFailureThreadMessage >> contentText [
	^ self failureText
]

{ #category : #accessing }
GtOpenAIFailureThreadMessage >> elementClass [
	^ GtOpenAIThreadMessageElement
]

{ #category : #accessing }
GtOpenAIFailureThreadMessage >> failureText [
	^ failureText
]

{ #category : #accessing }
GtOpenAIFailureThreadMessage >> failureText: anObject [
	failureText := anObject
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
