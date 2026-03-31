"
Represents a successful result for a stored object retrieval with the serialized object value and optional object ID.
"
Class {
	#name : #GtLObjectStorageValueResult,
	#superclass : #Object,
	#instVars : [
		'objectValue',
		'objectId',
		'object'
	],
	#category : #Gt4LlmCore
}

{ #category : #'instance creation' }
GtLObjectStorageValueResult class >> forObject: anObject withId: anObjectId [
	^ self new 
		object: anObject;
		objectValue: (GtLSerializedObjectValue fromObject: anObject);
		objectId: anObjectId
]

{ #category : #'gt-extensions' }
GtLObjectStorageValueResult >> gtObjectFor: aView [
	<gtView>
	<gtLlmView>
	^ aView explicit
		title: 'Object';
		priority: 9;
		stencil: [ ((self object gtViewsFor: GtPhlowEmptyView new) asElement
			margin: (BlInsets all: 10);
			background: Color white;
			addAptitude: BrShadowAptitude;
			matchParent) ]
]

{ #category : #'llm views' }
GtLObjectStorageValueResult >> llmRawDataViewFor: aDataView [
	<gtLlmDataView>
	
	^ aDataView magritteObject
			title: 'Object generic details';
			object: [ self ]
]

{ #category : #'llm views' }
GtLObjectStorageValueResult >> llmSpecificObjectViewFor: aDataView [
	<gtLlmDataView>
	
	^ aDataView forwardObject
			title: 'Object specific details';
			dataKey: 'objectDetails';
			object: [ self object ]
]

{ #category : #accessing }
GtLObjectStorageValueResult >> object [
	^ object
]

{ #category : #accessing }
GtLObjectStorageValueResult >> object: anObject [
	object := anObject
]

{ #category : #accessing }
GtLObjectStorageValueResult >> objectId [
	^ objectId
]

{ #category : #accessing }
GtLObjectStorageValueResult >> objectId: aString [
	objectId := aString
]

{ #category : #descriptions }
GtLObjectStorageValueResult >> objectIdDescription [
	<magritteDescription>
	^ MAStringDescription new
		label: 'Object id';
		accessor: #objectId;
		beOptional
]

{ #category : #accessing }
GtLObjectStorageValueResult >> objectValue [
	^ objectValue
]

{ #category : #accessing }
GtLObjectStorageValueResult >> objectValue: aSerializedObjectValue [
	objectValue := aSerializedObjectValue
]

{ #category : #descriptions }
GtLObjectStorageValueResult >> objectValueDescription [
	<magritteDescription>
	^ MAToOneRelationDescription new
		label: 'Object value';
		accessor: #objectValue;
		classes: { GtLSerializedObjectValue };
		beRequired
]

{ #category : #printing }
GtLObjectStorageValueResult >> printOn: aStream [
	super printOn: aStream.
	aStream
		nextPut: $(;
		nextPutAll: (self objectId ifNil: [ '' ] ifNotNil: [ self objectId ]);
		nextPut: $)
]
