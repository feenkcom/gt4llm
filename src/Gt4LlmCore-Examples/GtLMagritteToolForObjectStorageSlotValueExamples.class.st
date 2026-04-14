"
Examples for GtLMagritteToolForObjectStorageSlotValue.
"
Class {
	#name : #GtLMagritteToolForObjectStorageSlotValueExamples,
	#superclass : #GtLAbstractMagritteFunctionToolExamples,
	#category : 'Gt4LlmCore-Examples-Tools'
}

{ #category : #examples }
GtLMagritteToolForObjectStorageSlotValueExamples >> retrieveMissingSlotValue [
	<gtExample>
	| objectStorage storedObjectId call |
	objectStorage := GtLObjectStorage new.
	storedObjectId := objectStorage addNewObject: GtLSerializedObjectValueTestObject exampleInstance reason: 'example object'.
	call := self
		executeTool: GtLMagritteToolForObjectStorageSlotValue new
		withArguments: {
			'objectId' -> storedObjectId.
			'slotName' -> 'missingSlot'
		} asDictionary
		inContext: (GtLToolExecutionContext new objectStorage: objectStorage).
	self
		assertMissingObject: call result targetObject
		withObjectName: 'missingSlot'
		errorMessage: 'missingSlot is not found'.
	^ call
]

{ #category : #examples }
GtLMagritteToolForObjectStorageSlotValueExamples >> retrieveMissingStoredObjectSlotValue [
	<gtExample>
	| objectStorage call |
	objectStorage := GtLObjectStorage new.
	call := self
		executeTool: GtLMagritteToolForObjectStorageSlotValue new
		withArguments: {
			'objectId' -> 'missing-object-id'.
			'slotName' -> 'name'
		} asDictionary
		inContext: (GtLToolExecutionContext new objectStorage: objectStorage).
	self
		assertMissingObject: call result targetObject
		withObjectName: 'missing-object-id'
		errorMessage: 'missing-object-id is not found'.
	^ call
]

{ #category : #examples }
GtLMagritteToolForObjectStorageSlotValueExamples >> retrieveSlotValueWithEmptySlotName [
	<gtExample>
	| objectStorage storedObjectId call |
	objectStorage := GtLObjectStorage new.
	storedObjectId := objectStorage addNewObject: GtLSerializedObjectValueTestObject exampleInstance reason: 'example object'.
	call := self
		executeTool: GtLMagritteToolForObjectStorageSlotValue new
		withArguments: { 
			'objectId' -> storedObjectId.
			'slotName' -> '   '
		} asDictionary
		inContext: (GtLToolExecutionContext new objectStorage: objectStorage).
	self
		assertMissingArgument: call result targetObject
		withArgumentName: 'slotName'
		errorMessage: 'Missing argument called slotName'.
	^ call
]

{ #category : #examples }
GtLMagritteToolForObjectStorageSlotValueExamples >> retrieveSlotValueWithMissingObjectId [
	<gtExample>
	| objectStorage call |
	objectStorage := GtLObjectStorage new.
	call := self
		executeTool: GtLMagritteToolForObjectStorageSlotValue new
		withArguments: { 'slotName' -> 'name' } asDictionary
		inContext: (GtLToolExecutionContext new objectStorage: objectStorage).
	self
		assertMissingRequiredProperties: call result targetObject
		withPropertyNames: #('objectId')
		path: #(nil)
		errorMessage: 'required properties missing [objectId]'.
	^ call
]

{ #category : #examples }
GtLMagritteToolForObjectStorageSlotValueExamples >> retrieveSlotValueWithMissingSlotName [
	<gtExample>
	| objectStorage storedObjectId call |
	objectStorage := GtLObjectStorage new.
	storedObjectId := objectStorage addNewObject: GtLSerializedObjectValueTestObject exampleInstance reason: 'example object'.
	call := self
		executeTool: GtLMagritteToolForObjectStorageSlotValue new
		withArguments: { 'objectId' -> storedObjectId } asDictionary
		inContext: (GtLToolExecutionContext new objectStorage: objectStorage).
	self
		assertMissingRequiredProperties: call result targetObject
		withPropertyNames: #('slotName')
		path: #(nil)
		errorMessage: 'required properties missing [slotName]'.
	^ call
]

{ #category : #examples }
GtLMagritteToolForObjectStorageSlotValueExamples >> retrieveStoredObjectSlotValue [
	<gtExample>
	| objectStorage storedObjectId call targetObject |
	objectStorage := GtLObjectStorage new.
	storedObjectId := objectStorage addNewObject: GtLSerializedObjectValueTestObject exampleInstance reason: 'example object'.
	call := self
		executeTool: GtLMagritteToolForObjectStorageSlotValue new
		withArguments: {
			'objectId' -> storedObjectId.
			'slotName' -> 'name'
		} asDictionary
		inContext: (GtLToolExecutionContext new objectStorage: objectStorage).
	targetObject := call result targetObject.
	self assert: (targetObject isKindOf: GtLObjectStorageValueResult).
	self assert: targetObject object equals: 'TestObject'.
	self assert: targetObject objectId equals: storedObjectId.
	self assert: targetObject objectValue objectClassName equals: 'ByteString'.
	self assert: (targetObject objectValue objectPrintString includesSubstring: 'TestObject').
	^ call
]

{ #category : #examples }
GtLMagritteToolForObjectStorageSlotValueExamples >> retrieveStoredObjectSlotValueWithoutStorage [
	<gtExample>
	| call |
	call := self
		executeTool: GtLMagritteToolForObjectStorageSlotValue new
		withArguments: {
			'objectId' -> 'missing'.
			'slotName' -> 'name'
		} asDictionary.
	self
		assertMissingInformation: call result targetObject
		withModelName: 'objectStorage'
		errorMessage: 'Missing objectStorage'.
	^ call
]
