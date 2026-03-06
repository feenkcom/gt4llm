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
	<return: #Object>
	| objectStorage object objectId presentObject |
	
	objectStorage := self newObjectStorage.
	object := Object new.
	objectId := objectStorage addNewObject: object.
	
	self assert: (objectStorage objectAt: objectId) == object.
	presentObject := objectStorage
		objectAt: objectId
		ifPresent: [ :found | found ]
		ifAbsent: [ nil ].
	self assert: presentObject == object.
	
	^ object
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
GtLObjectStorageExamples >> addingSameObjectTwiceAddsTwoObjects [
	<gtExample>
	<return: #Object>
	| objectStorage object objectIdOne objectIdTwo |
	
	objectStorage := self newObjectStorage.
	object := Object new.
	objectIdOne := objectStorage addNewObject: object.
	objectIdTwo := objectStorage addNewObject: object.
	
	self assert: objectStorage objectCount equals: 2.
	self assert: (objectStorage objectAt: objectIdOne) == object.
	self assert: (objectStorage objectAt: objectIdTwo) == object.
	^ objectStorage
]

{ #category : #examples }
GtLObjectStorageExamples >> addObjectAnswersId [
	<gtExample>
	<return: #String>
	| objectStorage objectId |
	
	objectStorage := self newObjectStorage.
	objectId := objectStorage addNewObject: Object new.
	self assert: objectId isString.
	self assert: (objectStorage includesObjectWithId: objectId).
	
	^ objectStorage
]

{ #category : #examples }
GtLObjectStorageExamples >> clearStorageRemovesObjects [
	<gtExample>
	<return: #Number>
	| objectStorage objectId |
	
	objectStorage := self newObjectStorage.
	objectId := objectStorage addNewObject: Object new.
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
	<return: #Number>
	| objectStorage |
	objectStorage := self newObjectStorage.
	
	objectStorage addNewObject: Object new.
	objectStorage addNewObject: Object new.
	self assert: objectStorage objectCount equals: 2.
	
	^ objectStorage 
]
