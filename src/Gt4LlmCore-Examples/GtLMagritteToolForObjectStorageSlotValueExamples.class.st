"
Examples for GtLMagritteToolForObjectStorageSlotValue.
"
Class {
	#name : #GtLMagritteToolForObjectStorageSlotValueExamples,
	#superclass : #Object,
	#traits : 'TGtLInvalidInputDataAssertions',
	#classTraits : 'TGtLInvalidInputDataAssertions classTrait',
	#category : #'Gt4LlmCore-Examples-Tools'
}

{ #category : #examples }
GtLMagritteToolForObjectStorageSlotValueExamples >> retrieveMissingSlotValue [
	<gtExample>
	| objectStorage storedObjectId tool call result domainObject |
	objectStorage := GtLObjectStorage new.
	storedObjectId := objectStorage addNewObject: GtLSerializedObjectValueTestObject exampleInstance reason: 'example object'.
	tool := GtLMagritteToolForObjectStorageSlotValue new.
	call := GtLFunctionToolCall new.
	call rawArguments: {
		'objectId' -> storedObjectId.
		'slotName' -> 'missingSlot'
	} asDictionary.
	result := tool
		performToolCall: call
		inContext: (GtLToolExecutionContext new objectStorage: objectStorage).
	self assert: call tool == tool.
	self assert: (result isKindOf: GTLDataViewWrapperModel).
	domainObject := result targetObject.
	self
		assertMissingObject: domainObject
		withObjectName: 'missingSlot'
		errorMessage: 'missingSlot is not found'.
	^ domainObject
]

{ #category : #examples }
GtLMagritteToolForObjectStorageSlotValueExamples >> retrieveMissingStoredObjectSlotValue [
	<gtExample>
	| objectStorage tool call result domainObject |
	objectStorage := GtLObjectStorage new.
	tool := GtLMagritteToolForObjectStorageSlotValue new.
	call := GtLFunctionToolCall new.
	call rawArguments: {
		'objectId' -> 'missing-object-id'.
		'slotName' -> 'name'
	} asDictionary.
	result := tool
		performToolCall: call
		inContext: (GtLToolExecutionContext new objectStorage: objectStorage).
	self assert: call tool == tool.
	self assert: (result isKindOf: GTLDataViewWrapperModel).
	domainObject := result targetObject.
	self
		assertMissingObject: domainObject
		withObjectName: 'missing-object-id'
		errorMessage: 'missing-object-id is not found'.
	^ domainObject
]

{ #category : #examples }
GtLMagritteToolForObjectStorageSlotValueExamples >> retrieveSlotValueWithEmptySlotName [
	<gtExample>
	| objectStorage storedObjectId tool call result domainObject |
	objectStorage := GtLObjectStorage new.
	storedObjectId := objectStorage addNewObject: GtLSerializedObjectValueTestObject exampleInstance reason: 'example object'.
	tool := GtLMagritteToolForObjectStorageSlotValue new.
	call := GtLFunctionToolCall new.
	call rawArguments: { 
		'objectId' -> storedObjectId.
		'slotName' -> '   '
	} asDictionary.
	result := tool
		performToolCall: call
		inContext: (GtLToolExecutionContext new objectStorage: objectStorage).
	self assert: call tool == tool.
	self assert: (result isKindOf: GTLDataViewWrapperModel).
	domainObject := result targetObject.
	self
		assertMissingArgument: domainObject
		withArgumentName: 'slotName'
		errorMessage: 'Missing argument called slotName'.
	^ domainObject
]

{ #category : #examples }
GtLMagritteToolForObjectStorageSlotValueExamples >> retrieveSlotValueWithMissingObjectId [
	<gtExample>
	| objectStorage tool call result domainObject |
	objectStorage := GtLObjectStorage new.
	tool := GtLMagritteToolForObjectStorageSlotValue new.
	call := GtLFunctionToolCall new.
	call rawArguments: { 'slotName' -> 'name' } asDictionary.
	result := tool
		performToolCall: call
		inContext: (GtLToolExecutionContext new objectStorage: objectStorage).
	self assert: call tool == tool.
	self assert: (result isKindOf: GTLDataViewWrapperModel).
	domainObject := result targetObject.
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
	| objectStorage storedObjectId tool call result domainObject |
	objectStorage := GtLObjectStorage new.
	storedObjectId := objectStorage addNewObject: GtLSerializedObjectValueTestObject exampleInstance reason: 'example object'.
	tool := GtLMagritteToolForObjectStorageSlotValue new.
	call := GtLFunctionToolCall new.
	call rawArguments: { 'objectId' -> storedObjectId } asDictionary.
	result := tool
		performToolCall: call
		inContext: (GtLToolExecutionContext new objectStorage: objectStorage).
	self assert: call tool == tool.
	self assert: (result isKindOf: GTLDataViewWrapperModel).
	domainObject := result targetObject.
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
	| objectStorage storedObjectId tool call result domainObject |
	objectStorage := GtLObjectStorage new.
	storedObjectId := objectStorage addNewObject: GtLSerializedObjectValueTestObject exampleInstance reason: 'example object'.
	tool := GtLMagritteToolForObjectStorageSlotValue new.
	call := GtLFunctionToolCall new.
	call rawArguments: {
		'objectId' -> storedObjectId.
		'slotName' -> 'name'
	} asDictionary.
	result := tool
		performToolCall: call
		inContext: (GtLToolExecutionContext new objectStorage: objectStorage).
	self assert: call tool == tool.
	self assert: (result isKindOf: GTLDataViewWrapperModel).
	domainObject := result targetObject.
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
	| tool call result domainObject |
	tool := GtLMagritteToolForObjectStorageSlotValue new.
	call := GtLFunctionToolCall new.
	call rawArguments: {
		'objectId' -> 'missing'.
		'slotName' -> 'name'
	} asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: (result isKindOf: GTLDataViewWrapperModel).
	domainObject := result targetObject.
	self
		assertMissingInformation: domainObject
		withModelName: 'objectStorage'
		errorMessage: 'Missing objectStorage'.
	^ domainObject
]
