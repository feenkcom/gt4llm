Class {
	#name : #GtLlmErrorThreadMessage,
	#superclass : #Object,
	#instVars : [
		'exception',
		'createdAt',
		'chat'
	],
	#category : #Gt4Llm
}

{ #category : #'as yet unclassified' }
GtLlmErrorThreadMessage >> action [
	^ nil
]

{ #category : #accessing }
GtLlmErrorThreadMessage >> ancestor [
	^ self chat messages first
]

{ #category : #accessing }
GtLlmErrorThreadMessage >> annotations [
	^ #()
]

{ #category : #'as yet unclassified' }
GtLlmErrorThreadMessage >> arguments [
	^ {}
]

{ #category : #accessing }
GtLlmErrorThreadMessage >> chat [
	^ chat
]

{ #category : #accessing }
GtLlmErrorThreadMessage >> chat: anObject [
	chat := anObject
]

{ #category : #'as yet unclassified' }
GtLlmErrorThreadMessage >> content [
	^ self contentText
]

{ #category : #'as yet unclassified' }
GtLlmErrorThreadMessage >> contentJson [
	^ {} asDictionary
]

{ #category : #accessing }
GtLlmErrorThreadMessage >> contentSummary [
	^ self contentText lines ifEmpty: [ '' ] ifNotEmpty: #first
]

{ #category : #accessing }
GtLlmErrorThreadMessage >> contentText [
	^ self exception messageText
]

{ #category : #accessing }
GtLlmErrorThreadMessage >> createdAt [
	^ createdAt
]

{ #category : #accessing }
GtLlmErrorThreadMessage >> createdAt: anObject [
	createdAt := anObject
]

{ #category : #accessing }
GtLlmErrorThreadMessage >> exception [
	^ exception
]

{ #category : #accessing }
GtLlmErrorThreadMessage >> exception: anObject [
	exception := anObject
]

{ #category : #testing }
GtLlmErrorThreadMessage >> hasResponse [
	^ true
]

{ #category : #accessing }
GtLlmErrorThreadMessage >> id [
	^ '3a876ca3-32ce-0d00-b7b2-b9390ae84159'
]

{ #category : #'as yet unclassified' }
GtLlmErrorThreadMessage >> initialize [
	super initialize.
	
	self createdAt: DateAndTime now.
]

{ #category : #testing }
GtLlmErrorThreadMessage >> isAssistantRole [
	^ true
]

{ #category : #testing }
GtLlmErrorThreadMessage >> isFailure [
	^ true
]

{ #category : #testing }
GtLlmErrorThreadMessage >> isRawMessage [
	^ false
]

{ #category : #'as yet unclassified' }
GtLlmErrorThreadMessage >> isToolMessage [

	^ false
]

{ #category : #'as yet unclassified' }
GtLlmErrorThreadMessage >> role [
	^ 'Error'
]

{ #category : #accessing }
GtLlmErrorThreadMessage >> senderText [
	^  'System'
]

{ #category : #accessing }
GtLlmErrorThreadMessage >> styler [
	^ nil
]

{ #category : #subscriptions }
GtLlmErrorThreadMessage >> unsubscribe: anObject [
	"do nothing"

	
]

{ #category : #subscriptions }
GtLlmErrorThreadMessage >> when: anEventSelector send: aMessageSelector to: anObject [
	"do nothing"

	
]
