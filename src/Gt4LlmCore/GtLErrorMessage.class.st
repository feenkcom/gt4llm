Class {
	#name : #GtLErrorMessage,
	#superclass : #GtLChatMessage,
	#instVars : [
		'exception',
		'otherExceptions'
	],
	#category : #'Gt4LlmCore-Core'
}

{ #category : #accessing }
GtLErrorMessage class >> defaultRole [
	^ 'error'
]

{ #category : #'instance creation' }
GtLErrorMessage class >> freeze: anError [ 
	^ self new exception: (GtSystemUtility freeze: anError)
]

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

{ #category : #accessing }
GtLErrorMessage >> chat: aChat [
	[ super chat: aChat ]
		on: Error
		do: [ :anError | 
			self otherException: (GtSystemUtility freeze: anError) ]
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

{ #category : #accessing }
GtLErrorMessage >> exception [
	^ exception
]

{ #category : #accessing }
GtLErrorMessage >> exception: anException [
	exception := anException
]

{ #category : #views }
GtLErrorMessage >> gtExceptionStackFor: aView [
	<gtView>
	^ aView forward
		title: 'Exception stack';
		object: [ exception ];
		view: #gtLiveFor:
]

{ #category : #initialization }
GtLErrorMessage >> initialize [
	super initialize.
	
	otherExceptions := #().
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

{ #category : #testing }
GtLErrorMessage >> isToolMessage [

	^ false
]

{ #category : #'api - testing' }
GtLErrorMessage >> isUserRole [
	^ false
]

{ #category : #accessing }
GtLErrorMessage >> otherException: anError [
	self otherExceptions: (self otherExceptions copyWith: anError)
]

{ #category : #accessing }
GtLErrorMessage >> otherExceptions [
	^ otherExceptions
]

{ #category : #accessing }
GtLErrorMessage >> otherExceptions: aCollection [
	otherExceptions := aCollection
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
