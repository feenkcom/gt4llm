Class {
	#name : #GtLObjectStorage,
	#superclass : #Object,
	#instVars : [
		'objectsByUUID'
	],
	#category : #'Gt4LlmCore-Core'
}

{ #category : #'api - adding' }
GtLObjectStorage >> addNewObject: anObject [
	"Add an object without checking if it already exists. Return the id of the object"
	| newUUID |
	
	newUUID := self generateNewUUID.
	objectsByUUID 
		at: newUUID
		put: anObject.
		
	^  newUUID asString36
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

{ #category : #views }
GtLObjectStorage >> gtObjectsByUUIDFor: aView [
	<gtView>
	objectsByUUID ifNil: [ ^ aView empty ].
	^ aView columnedList
		title: 'Objects by UUID';
		items: [ objectsByUUID associations ];
		column: 'Key' text: [ :each | each key asString36 ] width: 200;
		column: 'Value' text: [ :each | each value ]; 
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

{ #category : #'api - accessing' }
GtLObjectStorage >> objectAt: anObjectId [ 
	| internalId |
	
	internalId := self convertToInternalId: anObjectId.
	^ objectsByUUID  at: internalId 
]

{ #category : #'api - accessing' }
GtLObjectStorage >> objectAt: anObjectId ifPresent: aPresentBlock ifAbsent: anAbsentBlock [
	| internalId |
	
	internalId := self convertToInternalId: anObjectId.
	^ objectsByUUID 
		at: internalId ifPresent: aPresentBlock ifAbsent: anAbsentBlock
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
