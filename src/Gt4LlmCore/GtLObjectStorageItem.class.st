Class {
	#name : #GtLObjectStorageItem,
	#superclass : #Object,
	#instVars : [
		'objectId',
		'objectValue'
	],
	#category : #Gt4LlmCore
}

{ #category : #accessing }
GtLObjectStorageItem >> gtValueFor: aView [
	<gtView>
	<gtLlmView>
	^ aView columnedList
		title: 'Object storage item';
		priority: 1;
		items: [ { self } ];
		column: 'Object Id' text: [ :each | each objectId ];
		column: 'Object' text: [ :each | each objectValueString ]
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
	^ [ self objectValue gtDisplayString ]
		on: Error
		do: [ :anError | 'Error printing object' ]
]
