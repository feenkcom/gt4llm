Class {
	#name : #GtLObjectStorage,
	#superclass : #Object,
	#instVars : [
		'objectsByUUID'
	],
	#category : 'Gt4LlmCore-Object Storage'
}

{ #category : #accessing }
GtLObjectStorage >> addNewObject: anObject [
	^ self addNewObject: anObject reason: (GtLStoredObjectStringReason text: '')
]

{ #category : #accessing }
GtLObjectStorage >> addNewObject: anObject reason: aReason [
	"Add an object without checking if it already exists. Return the id of the object"

	| newUUID storedObject |
	newUUID := self generateNewUUID.
	storedObject := GtLStoredObject
			id: newUUID
			value: anObject
			reason: aReason.
	objectsByUUID at: newUUID put: storedObject.

	^ newUUID asString36
]

{ #category : #'api - cleaning' }
GtLObjectStorage >> clearCache [
	objectsByUUID := Dictionary new.
]

{ #category : #utils }
GtLObjectStorage >> convertToInternalId: anObjectId [
	^ UUID fromString36: anObjectId
]

{ #category : #utils }
GtLObjectStorage >> generateNewUUID [
	"TODO: extend to check that the UUID does not exist"
	^ UUID new
]

{ #category : #'gt views' }
GtLObjectStorage >> gtObjectsByUUIDFor: aView [
	<gtView>
	objectsByUUID ifNil: [ ^ aView empty ].
	^ aView columnedList
		title: 'Objects by UUID';
		items: [ objectsByUUID values ];
		column: 'Key' text: [ :each | each id asString36 ] width: 200;
		column: 'Value' text: [ :each | each value ];
		column: 'Reason' text: [ :each | each reason asReasonString ];
		send: [ :each | each value ]
]

{ #category : #'api - testing' }
GtLObjectStorage >> includesObjectWithId: anObjectId [
	| internalId |
	internalId := self convertToInternalId: anObjectId.
	^ objectsByUUID includesKey: internalId
]

{ #category : #initialization }
GtLObjectStorage >> initialize [
	super initialize.
	
	self clearCache.
]

{ #category : #accessing }
GtLObjectStorage >> objectAt: anObjectId [ 
	^ (self storedObjectAt: anObjectId) value
]

{ #category : #accessing }
GtLObjectStorage >> objectAt: anObjectId ifPresent: aPresentBlock ifAbsent: anAbsentBlock [
	^ self
		storedObjectAt: anObjectId
		ifPresent: [ :aStoredObject | aPresentBlock value: aStoredObject value ]
		ifAbsent: anAbsentBlock
]

{ #category : #'api - accessing' }
GtLObjectStorage >> objectCount [
	^ objectsByUUID size
]

{ #category : #'utils - accessing' }
GtLObjectStorage >> objectIds [
	^ objectsByUUID keys collect: [ :each |
			each asString36 ]
]

{ #category : #printing }
GtLObjectStorage >> printOn: aStream [
	super printOn: aStream.

	aStream 
		<< ' [';
		print: self objectCount;
		<< ' ';
		<< ('object' asPluralBasedOn: self objectCount);
		<< ']'
]

{ #category : #'as yet unclassified' }
GtLObjectStorage >> size [
	^ objectsByUUID size
]

{ #category : #accessing }
GtLObjectStorage >> storedObjectAt: anObjectId [
	| internalId |
	
	internalId := self convertToInternalId: anObjectId.
	^ objectsByUUID at: internalId
]

{ #category : #accessing }
GtLObjectStorage >> storedObjectAt: anObjectId ifPresent: aPresentBlock ifAbsent: anAbsentBlock [
	| internalId |
	
	internalId := self convertToInternalId: anObjectId.
	^ objectsByUUID 
		at: internalId
		ifPresent: aPresentBlock
		ifAbsent: anAbsentBlock
]
