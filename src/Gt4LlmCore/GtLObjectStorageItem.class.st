Class {
	#name : #GtLObjectStorageItem,
	#superclass : #Object,
	#instVars : [
		'objectId',
		'objectValue',
		'reason'
	],
	#category : 'Gt4LlmCore-Magritte Objects'
}

{ #category : #'gt views' }
GtLObjectStorageItem >> gtValueFor: aView [
	<gtView>
	<gtLlmView>
	^ aView columnedList
		title: 'Object storage item';
		priority: 1;
		items: [ { self } ];
		column: 'Object Id' text: [ :each | each objectId ];
		column: 'Object' text: [ :each | each objectValueString ];
		column: 'Reason' text: [ :each | each reasonString ]
]

{ #category : #'llm views' }
GtLObjectStorageItem >> llmRawDataViewFor: aDataView [
	<gtLlmDataView>
	
	^ aDataView magritteObject: [ self ]
]

{ #category : #accessing }
GtLObjectStorageItem >> objectId [
	^ objectId
]

{ #category : #accessing }
GtLObjectStorageItem >> objectId: anObject [
	objectId := anObject
]

{ #category : #magritte }
GtLObjectStorageItem >> objectIdDescription [
	<magritteDescription>

	^ MAStringDescription new
		label: 'Object id';
		accessor: #objectId;
		beRequired
]

{ #category : #accessing }
GtLObjectStorageItem >> objectValue [
	^ objectValue
]

{ #category : #accessing }
GtLObjectStorageItem >> objectValue: anObject [
	objectValue := anObject
]

{ #category : #accessing }
GtLObjectStorageItem >> objectValueDescription [
	<magritteDescription>

	^ MAStringDescription new
		label: 'Object value';
		accessor: #objectValueString;
		beRequired
]

{ #category : #accessing }
GtLObjectStorageItem >> objectValueString [
	^ [ | string |
	string := self objectValue printString.
	string first: (string size min: 100) ]
		on: Error
		do: [ :anError | 'Error printing object' ]
]

{ #category : #accessing }
GtLObjectStorageItem >> reason [
	^ reason
]

{ #category : #accessing }
GtLObjectStorageItem >> reason: aString [
	reason := aString
]

{ #category : #magritte }
GtLObjectStorageItem >> reasonDescription [
	<magritteDescription>

	^ MAStringDescription new
		label: 'Reason';
		accessor: #reasonString;
		beRequired
]

{ #category : #accessing }
GtLObjectStorageItem >> reasonString [
	^ reason ifNil: [ '' ] ifNotNil: [ reason asReasonString ]
]
