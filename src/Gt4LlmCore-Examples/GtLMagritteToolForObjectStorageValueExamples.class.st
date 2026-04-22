"
Examples for GtLMagritteToolForObjectStorageValue.
"
Class {
	#name : #GtLMagritteToolForObjectStorageValueExamples,
	#superclass : #GtLAbstractMagritteFunctionToolExamples,
	#category : 'Gt4LlmCore-Examples-Tools'
}

{ #category : #examples }
GtLMagritteToolForObjectStorageValueExamples >> retrieveMissingStoredObjectValue [
	<gtExample>
	| objectStorage call |
	objectStorage := GtLObjectStorage new.
	call := self
		executeTool: GtLMagritteToolForObjectStorageValue new
		withArguments: {
			'objectId' -> 'missing-object-id'
		} asDictionary
		inContext: (GtLToolExecutionContext new objectStorage: objectStorage).
	self
		assertMissingObject: call result targetObject
		withObjectName: 'missing-object-id'
		errorMessage: 'missing-object-id is not found'.
	^ call
]

{ #category : #examples }
GtLMagritteToolForObjectStorageValueExamples >> retrieveStoredObjectValue [
	<gtExample>
	| objectStorage storedObjectId call targetObject |
	objectStorage := GtLObjectStorage new.
	storedObjectId := objectStorage addNewObject: GtLSerializedObjectValueTestObject exampleInstance reason: 'example object'.
	call := self
		executeTool: GtLMagritteToolForObjectStorageValue new
		withArguments: {
			'objectId' -> storedObjectId
		} asDictionary
		inContext: (GtLToolExecutionContext new objectStorage: objectStorage).
	targetObject := call result targetObject.
	self assert: (targetObject isKindOf: GtLObjectStorageValueResult).
	self assert: targetObject object == (objectStorage objectAt: storedObjectId).
	self assert: targetObject objectId equals: storedObjectId.
	self assert: targetObject objectValue objectClassName equals: 'GtLSerializedObjectValueTestObject'.
	self assert: (targetObject objectValue phlowViews anySatisfy: [ :each | each title = 'Details' ]).
	self assert: targetObject objectValue allInstanceSlots size equals: 3.
	^ call
]

{ #category : #examples }
GtLMagritteToolForObjectStorageValueExamples >> retrieveStoredObjectValueWithEmptyObjectId [
	<gtExample>
	| objectStorage call |
	objectStorage := GtLObjectStorage new.
	call := self
		executeTool: GtLMagritteToolForObjectStorageValue new
		withArguments: { 'objectId' -> '   ' } asDictionary
		inContext: (GtLToolExecutionContext new objectStorage: objectStorage).
	self
		assertMissingArgument: call result targetObject
		withArgumentName: 'objectId'
		errorMessage: 'Missing argument called objectId'.
	^ call
]

{ #category : #examples }
GtLMagritteToolForObjectStorageValueExamples >> retrieveStoredObjectValueWithMissingObjectId [
	<gtExample>
	| objectStorage call |
	objectStorage := GtLObjectStorage new.
	call := self
		executeTool: GtLMagritteToolForObjectStorageValue new
		withArguments: Dictionary new
		inContext: (GtLToolExecutionContext new objectStorage: objectStorage).
	self
		assertMissingRequiredProperties: call result targetObject
		withPropertyNames: #('objectId')
		path: #(nil)
		errorMessage: 'required properties missing [objectId]'.
	^ call
]

{ #category : #examples }
GtLMagritteToolForObjectStorageValueExamples >> retrieveStoredObjectValueWithoutStorage [
	<gtExample>
	| call |
	call := self
		executeTool: GtLMagritteToolForObjectStorageValue new
		withArguments: {
			'objectId' -> 'missing'
		} asDictionary.
	self
		assertMissingInformation: call result targetObject
		withModelName: 'objectStorage'
		errorMessage: 'Missing objectStorage'.
	^ call
]
