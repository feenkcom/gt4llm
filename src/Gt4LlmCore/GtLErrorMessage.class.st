Class {
	#name : #GtLErrorMessage,
	#superclass : #GtLChatMessage,
	#instVars : [
		'exception',
		'otherExceptions',
		'inputMessage'
	],
	#category : 'Gt4LlmCore-Core'
}

{ #category : #'instance creation' }
GtLErrorMessage class >> freeze: anError [ 
	^ self new freeze: anError
]

{ #category : #accessing }
GtLErrorMessage class >> leJsonV4Name [
	^ #gtLErrorMessage
]

{ #category : #accessing }
GtLErrorMessage >> action [
	^ nil
]

{ #category : #accessing }
GtLErrorMessage >> chat: aChat [
	[ super chat: aChat ]
		on: Error
		do: [ :anError | 
			self otherException: (GtSystemUtility freeze: anError) ]
]

{ #category : #accessing }
GtLErrorMessage >> content [
	^ self contentText
]

{ #category : #accessing }
GtLErrorMessage >> contentText [
	^ self exception ifNil: [ 'Error' ] ifNotNil: [: e | e messageText ]
]

{ #category : #accessing }
GtLErrorMessage >> exception [
	^ exception
]

{ #category : #accessing }
GtLErrorMessage >> exception: anException [
	exception := anException
]

{ #category : #accessing }
GtLErrorMessage >> freeze: anError [ 
	self exception: (GtSystemUtility freeze: anError)
]

{ #category : #views }
GtLErrorMessage >> gtExceptionStackFor: aView [
	<gtView>
	<gtLlmView>
	self exception ifNil: [ ^ aView empty ].
	
	^ aView forward
		title: 'Exception stack';
		object: [ self exception ];
		view: #gtLiveFor:
]

{ #category : #'as yet unclassified' }
GtLErrorMessage >> hasCompactionResponse [
	^false
]

{ #category : #initialization }
GtLErrorMessage >> initialize [
	super initialize.
	
	otherExceptions := #().
	
	self flag: #todo. 
	"I doubt it is correct to set a fixed id. What if we have two error messages in the same list?"
	self id: '3a876ca3-32ce-0d00-b7b2-b9390ae84159'.
]

{ #category : #accessing }
GtLErrorMessage >> inputMessage [
	^ inputMessage
]

{ #category : #accessing }
GtLErrorMessage >> inputMessage: anObject [
	inputMessage := anObject
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
GtLErrorMessage >> role [
	"Supported roles for OpenAI are: 'assistant', 'system', 'developer', and 'user'"
	^ 'error'
]

{ #category : #accessing }
GtLErrorMessage >> senderText [
	^  'System'
]

{ #category : #'api - serializing' }
GtLErrorMessage >> serializeForOpenAIResponsesAPI [
	<return: #NeoJSONObject>
	^ NeoJSONObject new
		at: #role put: 'user';
		at: #content
			put: {NeoJSONObject new
						at: #type put: 'input_text';
						at: #text
							put: (STONJSON toString: (NeoJSONObject new
									at: #error put: self exception messageText;
									at: #errorClass put: self exception className;
									at: #description put: self exception description;
									at: #stackTrace put: self exception stackString;
									yourself));
						yourself};
		yourself
]

{ #category : #accessing }
GtLErrorMessage >> styler [
	^ nil
]

{ #category : #'announcer - subscription' }
GtLErrorMessage >> unsubscribe: anObject [
	"do nothing"

	
]

{ #category : #'api - converting' }
GtLErrorMessage >> viewModelClass [
	^ GtLErrorMessageViewModel
]

{ #category : #'announcer - subscription' }
GtLErrorMessage >> when: anEventSelector send: aMessageSelector to: anObject [
	"do nothing"

	
]
