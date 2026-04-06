Class {
	#name : #GtLObjectValueResult,
	#superclass : #Object,
	#instVars : [
		'object',
		'objectValue'
	],
	#category : 'Gt4LlmCore-Domain Objects'
}

{ #category : #'instance creation' }
GtLObjectValueResult class >> forObject: anObject [ 
	^ self new 
		object: anObject;
		objectValue: (GtLSerializedObjectValue fromObject: anObject)
]

{ #category : #testing }
GtLObjectValueResult >> isErrorDomainObject [
	"Return true if the domain object represents some kind of failure or exception,
	instead of an expected domain object."

	^ false
]

{ #category : #'llm views' }
GtLObjectValueResult >> llmRawDataViewFor: aDataView [
	<gtLlmDataView>
	
	^ aDataView magritteObject
			title: 'Object generic details';
			object: [ self ]
]

{ #category : #'llm views' }
GtLObjectValueResult >> llmSpecificObjectViewFor: aDataView [
	<gtLlmDataView>
	
	^ aDataView forwardObject
			title: 'Object specific details';
			dataKey: 'objectDetails';
			object: [ self object ]
]

{ #category : #accessing }
GtLObjectValueResult >> object [
	^ object
]

{ #category : #accessing }
GtLObjectValueResult >> object: anObject [
	object := anObject
]

{ #category : #accessing }
GtLObjectValueResult >> objectValue [
	^ objectValue
]

{ #category : #accessing }
GtLObjectValueResult >> objectValue: aSerializedObjectValue [
	objectValue := aSerializedObjectValue
]

{ #category : #descriptions }
GtLObjectValueResult >> objectValueDescription [
	<magritteDescription>
	^ MAToOneRelationDescription new
		label: 'Object value';
		accessor: #objectValue;
		classes: { GtLSerializedObjectValue };
		beRequired
]

{ #category : #printing }
GtLObjectValueResult >> printOn: aStream [
	self object printOn: aStream
]
