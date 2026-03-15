"
Examples for GtLObjectCache
"
Class {
	#name : #GtLObjectStorageExamples,
	#superclass : #Object,
	#category : #'Gt4LlmCore-Examples'
}

{ #category : #examples }
GtLObjectStorageExamples >> accessingObjectReturnsStoredObject [
	<gtExample>
	<return: #GtLStoredObject>
	| objectStorage object objectId presentObject storedObject |
	
	objectStorage := self newObjectStorage.
	object := Object new.
	objectId := objectStorage addNewObject: object reason: 'for retrieval'.
	
	self assert: (objectStorage objectAt: objectId) == object.
	presentObject := objectStorage
		objectAt: objectId
		ifPresent: [ :found | found ]
		ifAbsent: [ nil ].
	self assert: presentObject == object.
	storedObject := objectStorage storedObjectAt: objectId.
	self assert: storedObject value == object.
	self assert: storedObject id equals: (UUID fromString36: objectId).
	self assert: storedObject reason equals: 'for retrieval'.
	
	^ storedObject
]

{ #category : #examples }
GtLObjectStorageExamples >> accessingObjectThatIsMissingReturnsMissing [
	<gtExample>
	<return: #String>
	| objectStorage absentResult |
	
	objectStorage := self newObjectStorage.
	absentResult := objectStorage
		objectAt: UUID new asString36
		ifPresent: [ 'present' ]
		ifAbsent: [ 'missing' ].
	self assert: absentResult equals: 'missing'.
	
	^ absentResult
]

{ #category : #examples }
GtLObjectStorageExamples >> addObjectAnswersId [
	<gtExample>
	<return: #GtLObjectStorage>
	| objectStorage objectId storedObject |
	
	objectStorage := self newObjectStorage.
	objectId := objectStorage addNewObject: Object new reason: 'test object'.
	storedObject := objectStorage storedObjectAt: objectId.
	self assert: objectId isString.
	self assert: (objectStorage includesObjectWithId: objectId).
	self assert: storedObject id equals: (UUID fromString36: objectId).
	self assert: storedObject reason equals: 'test object'.
	
	^ objectStorage
]

{ #category : #examples }
GtLObjectStorageExamples >> addingSameObjectTwiceAddsTwoObjects [
	<gtExample>
	<return: #GtLObjectStorage>
	| objectStorage object objectIdOne objectIdTwo |
	
	objectStorage := self newObjectStorage.
	object := Object new.
	objectIdOne := objectStorage addNewObject: object reason: 'first'.
	objectIdTwo := objectStorage addNewObject: object reason: 'second'.
	
	self assert: objectStorage objectCount equals: 2.
	self assert: (objectStorage objectAt: objectIdOne) == object.
	self assert: (objectStorage objectAt: objectIdTwo) == object.
	self assert: (objectStorage storedObjectAt: objectIdOne) reason equals: 'first'.
	self assert: (objectStorage storedObjectAt: objectIdTwo) reason equals: 'second'.
	^ objectStorage
]

{ #category : #examples }
GtLObjectStorageExamples >> clearStorageRemovesObjects [
	<gtExample>
	<return: #GtLObjectStorage>
	| objectStorage objectId |
	
	objectStorage := self newObjectStorage.
	objectId := objectStorage addNewObject: Object new reason: 'temporary'.
	self assert: (objectStorage includesObjectWithId: objectId).
	
	objectStorage clearCache.
	self assert: objectStorage objectCount equals: 0.
	self assert: (objectStorage includesObjectWithId: objectId) not.
	
	^ objectStorage
]

{ #category : #examples }
GtLObjectStorageExamples >> newObjectStorage [
	<gtExample>
	<return: #GtLObjectStorage>
	| objectStorage |
	
	objectStorage := GtLObjectStorage new.
	self assert: objectStorage objectCount equals: 0.
	
	^ objectStorage
]

{ #category : #examples }
GtLObjectStorageExamples >> objectCountTracksAddedObjects [
	<gtExample>
	<return: #GtLObjectStorage>
	| objectStorage |
	objectStorage := self newObjectStorage.
	
	objectStorage addNewObject: Object new reason: 'first object'.
	objectStorage addNewObject: Object new reason: 'second object'.
	self assert: objectStorage objectCount equals: 2.
	
	^ objectStorage
]

{ #category : #examples }
GtLObjectStorageExamples >> storedObjectIncludesIdValueAndReason [
	<gtExample>
	<return: #GtLStoredObject>
	| objectStorage value objectId storedObject |
	
	objectStorage := self newObjectStorage.
	value := Object new.
	objectId := objectStorage addNewObject: value reason: 'kept for later use'.
	storedObject := objectStorage storedObjectAt: objectId.
	
	self assert: storedObject id equals: (UUID fromString36: objectId).
	self assert: storedObject value == value.
	self assert: storedObject reason equals: 'kept for later use'.
	
	^ storedObject
]
