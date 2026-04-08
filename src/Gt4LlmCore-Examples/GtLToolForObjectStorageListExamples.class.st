Class {
	#name : #GtLToolForObjectStorageListExamples,
	#superclass : #GtLAbstractMagritteFunctionToolExamples,
	#category : #'Gt4LlmCore-Examples-Tools'
}

{ #category : #examples }
GtLToolForObjectStorageListExamples >> listEmptyObjectStorage [
	<gtExample>
	| objectStorage call targetObject |
	objectStorage := GtLObjectStorage new.
	call := self
		executeTool: GtLToolForObjectStorageList new
		withArguments: Dictionary new
		inContext: (GtLToolExecutionContext new objectStorage: objectStorage).
	targetObject := call result targetObject.
	self assert: (targetObject isKindOf: GtLObjectStorageItems).
	self assert: targetObject items isEmpty.
	^ call
]

{ #category : #examples }
GtLToolForObjectStorageListExamples >> listObjectsWithStorage [
	<gtExample>
	| objectStorage call targetObject oneItem twoItem |
	objectStorage := GtLObjectStorage new.
	objectStorage addNewObject: 'One' reason: (GtLStoredObjectStringReason text: 'first string').
	objectStorage addNewObject: 2 reason: (GtLStoredObjectStringReason text: 'second number').
	call := self
		executeTool: GtLToolForObjectStorageList new
		withArguments: Dictionary new
		inContext: (GtLToolExecutionContext new objectStorage: objectStorage).
	targetObject := call result targetObject.
	self assert: (targetObject isKindOf: GtLObjectStorageItems).
	self assert: targetObject items size equals: 2.
	self assert: (targetObject items collect: #objectValue) asSet equals: (Set with: 'One' with: 2).
	oneItem := targetObject items detect: [ :each | each objectValue = 'One' ].
	twoItem := targetObject items detect: [ :each | each objectValue = 2 ].
	self assert: oneItem reasonString equals: 'first string'.
	self assert: twoItem reasonString equals: 'second number'.
	^ call
]

{ #category : #examples }
GtLToolForObjectStorageListExamples >> listObjectsWithoutStorage [
	<gtExample>
	| call |
	call := self
		executeTool: GtLToolForObjectStorageList new
		withArguments: Dictionary new.
	self
		assertMissingInformation: call result targetObject
		withModelName: 'objectStorage'
		errorMessage: 'Missing objectStorage'.
	^ call
]
