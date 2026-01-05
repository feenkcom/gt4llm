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
GtLErrorMessage class >> leJsonV4Name [
	^ #gtLErrorMessage
]

{ #category : #'as yet unclassified' }
GtLErrorMessage >> action [
	^ nil
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
	self exception ifNil: [ ^ aView empty ].
	
	^ aView forward
		title: 'Exception stack';
		object: [ self exception ];
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
	"I am marked as assistant because I am the last message in an attempt to answer a user question.
	Note, that the failure can come from a tool execution or any other execution code while
	sending and retrieving information."

	^ true
]

{ #category : #testing }
GtLErrorMessage >> isFailure [
	^ true
]

{ #category : #'api - testing' }
GtLErrorMessage >> isUserRole [
	^ false
]

{ #category : #accessing }
GtLErrorMessage >> otherException: anException [
	"Add an exception that was catched while handling the initial exception."

	self otherExceptions: (self otherExceptions copyWith: anException)
]

{ #category : #accessing }
GtLErrorMessage >> otherExceptions [
	"Return a list of exceptions that were catched while handling the initial exception."

	^ otherExceptions
]

{ #category : #accessing }
GtLErrorMessage >> otherExceptions: aCollection [
	"Set a list of exceptions that were catched while handling the initial exception."

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

{ #category : #'announcer - subscription' }
GtLErrorMessage >> unsubscribe: anObject [
	"do nothing"

	
]

{ #category : #'announcer - subscription' }
GtLErrorMessage >> when: anEventSelector send: aMessageSelector to: anObject [
	"do nothing"

	
]
