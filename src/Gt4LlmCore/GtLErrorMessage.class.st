Class {
	#name : #GtLErrorMessage,
	#superclass : #GtLChatMessage,
	#instVars : [
		'exception'
	],
	#category : #'Gt4LlmCore-Core'
}

{ #category : #'as yet unclassified' }
GtLErrorMessage >> action [
	^ nil
]

{ #category : #accessing }
GtLErrorMessage >> ancestor [
	^ self chat messages first
]

{ #category : #accessing }
GtLErrorMessage >> annotations [
	^ #()
]

{ #category : #'as yet unclassified' }
GtLErrorMessage >> arguments [
	^ {}
]

{ #category : #'as yet unclassified' }
GtLErrorMessage >> content [
	^ self contentText
]

{ #category : #'as yet unclassified' }
GtLErrorMessage >> contentJson [
	^ {} asDictionary
]

{ #category : #accessing }
GtLErrorMessage >> contentSummary [
	^ self contentText lines ifEmpty: [ '' ] ifNotEmpty: #first
]

{ #category : #accessing }
GtLErrorMessage >> contentText [
	^ self exception messageText
]

{ #category : #'as yet unclassified' }
GtLErrorMessage >> defaultRole [
	^ 'Error'
]

{ #category : #accessing }
GtLErrorMessage >> exception [
	^ exception
]

{ #category : #accessing }
GtLErrorMessage >> exception: anObject [
	exception := anObject
]

{ #category : #testing }
GtLErrorMessage >> hasResponse [
	^ true
]

{ #category : #'as yet unclassified' }
GtLErrorMessage >> initialize [
	super initialize.
	
	self id: '3a876ca3-32ce-0d00-b7b2-b9390ae84159'.
	self createdAt: DateAndTime now.
]

{ #category : #testing }
GtLErrorMessage >> isAssistantRole [
	^ true
]

{ #category : #testing }
GtLErrorMessage >> isFailure [
	^ true
]

{ #category : #'as yet unclassified' }
GtLErrorMessage >> isToolMessage [

	^ false
]

{ #category : #'as yet unclassified' }
GtLErrorMessage >> isUserMessage [

	^ false
]

{ #category : #'api - testing' }
GtLErrorMessage >> isUserRole [
	^ false
]

{ #category : #accessing }
GtLErrorMessage >> senderText [
	^  'System'
]

{ #category : #accessing }
GtLErrorMessage >> styler [
	^ nil
]

{ #category : #subscriptions }
GtLErrorMessage >> unsubscribe: anObject [
	"do nothing"

	
]

{ #category : #subscriptions }
GtLErrorMessage >> when: anEventSelector send: aMessageSelector to: anObject [
	"do nothing"

	
]
