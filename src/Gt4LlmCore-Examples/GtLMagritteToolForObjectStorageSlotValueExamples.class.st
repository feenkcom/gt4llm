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
	| objectStorage storedObjectId tool domainObject |
	objectStorage := GtLObjectStorage new.
	storedObjectId := objectStorage addNewObject: GtLSerializedObjectValueTestObject exampleInstance reason: 'example object'.
	tool := GtLMagritteToolForObjectStorageSlotValue new.
	domainObject := self
		executeTool: tool
		withArguments: {
			'objectId' -> storedObjectId.
			'slotName' -> 'missingSlot'
		} asDictionary
		inContext: (GtLToolExecutionContext new objectStorage: objectStorage).
	self
		assertMissingObject: domainObject
		withObjectName: 'missingSlot'
		errorMessage: 'missingSlot is not found'.
	^ domainObject
]

{ #category : #examples }
GtLMagritteToolForObjectStorageSlotValueExamples >> retrieveMissingStoredObjectSlotValue [
	<gtExample>
	| objectStorage tool domainObject |
	objectStorage := GtLObjectStorage new.
	tool := GtLMagritteToolForObjectStorageSlotValue new.
	domainObject := self
		executeTool: tool
		withArguments: {
			'objectId' -> 'missing-object-id'.
			'slotName' -> 'name'
		} asDictionary
		inContext: (GtLToolExecutionContext new objectStorage: objectStorage).
	self
		assertMissingObject: domainObject
		withObjectName: 'missing-object-id'
		errorMessage: 'missing-object-id is not found'.
	^ domainObject
]

{ #category : #examples }
GtLMagritteToolForObjectStorageSlotValueExamples >> retrieveSlotValueWithEmptySlotName [
	<gtExample>
	| objectStorage storedObjectId tool domainObject |
	objectStorage := GtLObjectStorage new.
	storedObjectId := objectStorage addNewObject: GtLSerializedObjectValueTestObject exampleInstance reason: 'example object'.
	tool := GtLMagritteToolForObjectStorageSlotValue new.
	domainObject := self
		executeTool: tool
		withArguments: { 
			'objectId' -> storedObjectId.
			'slotName' -> '   '
		} asDictionary
		inContext: (GtLToolExecutionContext new objectStorage: objectStorage).
	self
		assertMissingArgument: domainObject
		withArgumentName: 'slotName'
		errorMessage: 'Missing argument called slotName'.
	^ domainObject
]

{ #category : #examples }
GtLMagritteToolForObjectStorageSlotValueExamples >> retrieveSlotValueWithMissingObjectId [
	<gtExample>
	| objectStorage tool domainObject |
	objectStorage := GtLObjectStorage new.
	tool := GtLMagritteToolForObjectStorageSlotValue new.
	domainObject := self
		executeTool: tool
		withArguments: { 'slotName' -> 'name' } asDictionary
		inContext: (GtLToolExecutionContext new objectStorage: objectStorage).
	self
		assertMissingRequiredProperties: domainObject
		withPropertyNames: #('objectId')
		path: #(nil)
		errorMessage: 'required properties missing [objectId]'.
	^ domainObject
]

{ #category : #examples }
GtLMagritteToolForObjectStorageSlotValueExamples >> retrieveSlotValueWithMissingSlotName [
	<gtExample>
	| objectStorage storedObjectId tool domainObject |
	objectStorage := GtLObjectStorage new.
	storedObjectId := objectStorage addNewObject: GtLSerializedObjectValueTestObject exampleInstance reason: 'example object'.
	tool := GtLMagritteToolForObjectStorageSlotValue new.
	domainObject := self
		executeTool: tool
		withArguments: { 'objectId' -> storedObjectId } asDictionary
		inContext: (GtLToolExecutionContext new objectStorage: objectStorage).
	self
		assertMissingRequiredProperties: domainObject
		withPropertyNames: #('slotName')
		path: #(nil)
		errorMessage: 'required properties missing [slotName]'.
	^ domainObject
]

{ #category : #examples }
GtLMagritteToolForObjectStorageSlotValueExamples >> retrieveStoredObjectSlotValue [
	<gtExample>
	| objectStorage storedObjectId tool domainObject |
	objectStorage := GtLObjectStorage new.
	storedObjectId := objectStorage addNewObject: GtLSerializedObjectValueTestObject exampleInstance reason: 'example object'.
	tool := GtLMagritteToolForObjectStorageSlotValue new.
	domainObject := self
		executeTool: tool
		withArguments: {
			'objectId' -> storedObjectId.
			'slotName' -> 'name'
		} asDictionary
		inContext: (GtLToolExecutionContext new objectStorage: objectStorage).
	self assert: (domainObject isKindOf: GtLObjectStorageValueResult).
	self assert: domainObject object equals: 'TestObject'.
	self assert: domainObject objectId equals: storedObjectId.
	self assert: domainObject objectValue objectClassName equals: 'ByteString'.
	self assert: (domainObject objectValue objectPrintString includesSubstring: 'TestObject').
	^ domainObject
]

{ #category : #examples }
GtLMagritteToolForObjectStorageSlotValueExamples >> retrieveStoredObjectSlotValueWithoutStorage [
	<gtExample>
	| tool domainObject |
	tool := GtLMagritteToolForObjectStorageSlotValue new.
	domainObject := self
		executeTool: tool
		withArguments: {
			'objectId' -> 'missing'.
			'slotName' -> 'name'
		} asDictionary.
	self
		assertMissingInformation: domainObject
		withModelName: 'objectStorage'
		errorMessage: 'Missing objectStorage'.
	^ domainObject
]
