Class {
	#name : #GtLExceptionDomainObject,
	#superclass : #GtLErroneousConditionDomainObject,
	#instVars : [
		'exception',
		'description'
	],
	#category : #'Gt4LlmCore-Domain Objects'
}

{ #category : #accessing }
GtLExceptionDomainObject >> description [
	^ description
]

{ #category : #accessing }
GtLExceptionDomainObject >> description: aString [
	"Set a short text that describes what failed"

	description := aString
]

{ #category : #accessing }
GtLExceptionDomainObject >> exception [
	^ exception
]

{ #category : #accessing }
GtLExceptionDomainObject >> exception: anObject [
	exception := anObject
]

{ #category : #accessing }
GtLExceptionDomainObject >> freeze: anException [
	self exception: (GtSystemUtility freeze: anException)
]

{ #category : #'gt - extensions' }
GtLExceptionDomainObject >> gtExceptionStackFor: aView [
	<gtView>
	<gtLlmView>
	exception ifNil: [ ^ aView empty ].
	
	^ aView forward
		title: 'Exception stack';
		priority: 1;
		object: [ self exception ];
		view: #gtLiveFor:
]

{ #category : #'api - accessing' }
GtLExceptionDomainObject >> messageText [
	"Return an error message"

	^ '{1}' format: {self exception}
]

{ #category : #'api - serializing' }
GtLExceptionDomainObject >> serializeToLlmJsonObject [
	"Return a JSON dictionary that represents the domain object."

	<return: #NeoJSONObject>
	^ NeoJSONObject new
		at: #error put: self messageText;
		at: #errorClass put: self exception className;
		at: #whatFailed put: self description;
		at: #stackTrace put: self stackTrace;
		yourself
]

{ #category : #'api - accessing' }
GtLExceptionDomainObject >> stackTrace [
	^ self exception signalerContext
		ifNotNil: [ :anInterruptedContext | String lf join: ((anInterruptedContext stackOfSize: 30) collect: #gtDisplayString) ]
		ifNil: [ | stackString |
			stackString := self exception stackString.
			stackString first: (1000 min: stackString size) ]
]
