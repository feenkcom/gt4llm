Class {
	#name : #GtLErrorThreadMessage,
	#superclass : #Object,
	#instVars : [
		'exception',
		'createdAt',
		'chat'
	],
	#category : #'Gt4LlmCore-Core'
}

{ #category : #'as yet unclassified' }
GtLErrorThreadMessage >> action [
	^ nil
]

{ #category : #accessing }
GtLErrorThreadMessage >> ancestor [
	^ self chat messages first
]

{ #category : #accessing }
GtLErrorThreadMessage >> annotations [
	^ #()
]

{ #category : #'as yet unclassified' }
GtLErrorThreadMessage >> arguments [
	^ {}
]

{ #category : #accessing }
GtLErrorThreadMessage >> chat [
	^ chat
]

{ #category : #accessing }
GtLErrorThreadMessage >> chat: anObject [
	chat := anObject
]

{ #category : #'as yet unclassified' }
GtLErrorThreadMessage >> content [
	^ self contentText
]

{ #category : #'as yet unclassified' }
GtLErrorThreadMessage >> contentJson [
	^ {} asDictionary
]

{ #category : #accessing }
GtLErrorThreadMessage >> contentSummary [
	^ self contentText lines ifEmpty: [ '' ] ifNotEmpty: #first
]

{ #category : #accessing }
GtLErrorThreadMessage >> contentText [
	^ self exception messageText
]

{ #category : #accessing }
GtLErrorThreadMessage >> createdAt [
	^ createdAt
]

{ #category : #accessing }
GtLErrorThreadMessage >> createdAt: anObject [
	createdAt := anObject
]

{ #category : #accessing }
GtLErrorThreadMessage >> exception [
	^ exception
]

{ #category : #accessing }
GtLErrorThreadMessage >> exception: anObject [
	exception := anObject
]

{ #category : #testing }
GtLErrorThreadMessage >> hasResponse [
	^ true
]

{ #category : #accessing }
GtLErrorThreadMessage >> id [
	^ '3a876ca3-32ce-0d00-b7b2-b9390ae84159'
]

{ #category : #'as yet unclassified' }
GtLErrorThreadMessage >> initialize [
	super initialize.
	
	self createdAt: DateAndTime now.
]

{ #category : #testing }
GtLErrorThreadMessage >> isAssistantRole [
	^ true
]

{ #category : #testing }
GtLErrorThreadMessage >> isFailure [
	^ true
]

{ #category : #testing }
GtLErrorThreadMessage >> isRawMessage [
	^ false
]

{ #category : #'as yet unclassified' }
GtLErrorThreadMessage >> isToolMessage [

	^ false
]

{ #category : #'as yet unclassified' }
GtLErrorThreadMessage >> isToolRole [
	^ false
]

{ #category : #'as yet unclassified' }
GtLErrorThreadMessage >> isUserMessage [

	^ false
]

{ #category : #'as yet unclassified' }
GtLErrorThreadMessage >> isUserRole [
	^ false
]

{ #category : #'as yet unclassified' }
GtLErrorThreadMessage >> role [
	^ 'Error'
]

{ #category : #accessing }
GtLErrorThreadMessage >> senderText [
	^  'System'
]

{ #category : #accessing }
GtLErrorThreadMessage >> styler [
	^ nil
]

{ #category : #subscriptions }
GtLErrorThreadMessage >> unsubscribe: anObject [
	"do nothing"

	
]

{ #category : #subscriptions }
GtLErrorThreadMessage >> when: anEventSelector send: aMessageSelector to: anObject [
	"do nothing"

	
]
