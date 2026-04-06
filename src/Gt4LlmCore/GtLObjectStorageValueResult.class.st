"
Represents a successful result for a stored object retrieval with the serialized object value and optional object ID.
"
Class {
	#name : #GtLObjectStorageValueResult,
	#superclass : #GtLObjectValueResult,
	#instVars : [
		'objectId'
	],
	#category : 'Gt4LlmCore-Domain Objects'
}

{ #category : #'instance creation' }
GtLObjectStorageValueResult class >> forObject: anObject withId: anObjectId [
	^ (self forObject: anObject)
			objectId: anObjectId
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

{ #category : #printing }
GtLObjectStorageValueResult >> printOn: aStream [
	super printOn: aStream.
	aStream
		nextPut: $(;
		nextPutAll: (self objectId ifNil: [ '' ] ifNotNil: [ self objectId ]);
		nextPut: $)
]
