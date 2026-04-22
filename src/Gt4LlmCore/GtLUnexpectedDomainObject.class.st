Class {
	#name : #GtLUnexpectedDomainObject,
	#superclass : #GtLErroneousConditionDomainObject,
	#instVars : [
		'objectName'
	],
	#category : 'Gt4LlmCore-Domain Objects'
}

{ #category : #'magritte-description' }
GtLUnexpectedDomainObject >> errorMessageDescription [
	<magritteDescription>
	^ MAStringDescription new
		label: 'Error';
		accessor: #messageText;
		beRequired
]

{ #category : #'llm - views' }
GtLUnexpectedDomainObject >> llmRawDataViewFor: aDataView [
	<gtLlmDataView>
	
	^ aDataView magritteObject: [ self ]
]

{ #category : #'api - accessing' }
GtLUnexpectedDomainObject >> messageText [
	"Return an error message"

	^ '{1} already exists' format: {self objectName}
]

{ #category : #accessing }
GtLUnexpectedDomainObject >> objectName [
	^ objectName
]

{ #category : #accessing }
GtLUnexpectedDomainObject >> objectName: anObject [
	"Set a name of the missing object."

	objectName := anObject
]

{ #category : #'magritte-description' }
GtLUnexpectedDomainObject >> objectNameDescription [
	<magritteDescription>
	^ MAStringDescription new
		label: 'Unexpected object';
		accessor: #objectName;
		beRequired
]
