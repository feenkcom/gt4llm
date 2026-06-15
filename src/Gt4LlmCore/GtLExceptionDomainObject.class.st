Class {
	#name : #GtLExceptionDomainObject,
	#superclass : #GtLObjectStorageValueResult,
	#instVars : [
		'exception',
		'errorReason'
	],
	#category : #'Gt4LlmCore-Domain Objects'
}

{ #category : #'instance creation' }
GtLExceptionDomainObject class >> freeze: anException [
	^self new 
		freeze: anException
]

{ #category : #accessing }
GtLExceptionDomainObject >> description [
	^ errorReason
]

{ #category : #accessing }
GtLExceptionDomainObject >> description: aString [
	"Set a short text that describes what failed"

	errorReason := aString
]

{ #category : #accessing }
GtLExceptionDomainObject >> errorReason [
	^ errorReason
]

{ #category : #accessing }
GtLExceptionDomainObject >> errorReason: aString [
	"Set a short text that describes what failed"

	errorReason := aString
]

{ #category : #descriptions }
GtLExceptionDomainObject >> errorReasonDescription [
	<magritteDescription>
	^ MAStringDescription new
		label: 'Error Reason';
		accessor: #errorReason;
		comment: 'An explicit reason for the error, when available';
		beOptional
]

{ #category : #accessing }
GtLExceptionDomainObject >> exception [
	^ self object
]

{ #category : #accessing }
GtLExceptionDomainObject >> exception: anObject [
	self object: anObject
]

{ #category : #accessing }
GtLExceptionDomainObject >> freeze: anException [
	self exception: (GtSystemUtility freeze: anException).
	self objectValue: (GtLSerializedObjectValue fromObject: anException)
]

{ #category : #'gt - extensions' }
GtLExceptionDomainObject >> gtExceptionStackFor: aView [
	<gtView>
	<gtLlmView>
	self exception ifNil: [ ^ aView empty ].

	^ aView forward
		title: 'Exception stack';
		priority: 1;
		object: [ self exception ];
		view: #gtLiveFor:;
		actionButtonIcon: BrGlamorousVectorIcons debug
			action: [ [ self exception debug ] fork ]
]

{ #category : #testing }
GtLExceptionDomainObject >> isErrorDomainObject [
	^ true
]

{ #category : #'api - accessing' }
GtLExceptionDomainObject >> messageText [
	"Return an error message"

	^ '{1}' format: {self exception}
]

{ #category : #accessing }
GtLExceptionDomainObject >> specificObjectPropertiesKey [
	^ 'errorDetails'
]
