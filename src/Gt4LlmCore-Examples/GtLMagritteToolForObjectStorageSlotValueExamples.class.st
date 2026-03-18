"
Examples for GtLMagritteToolForObjectStorageSlotValue.
"
Class {
	#name : #GtLMagritteToolForObjectStorageSlotValueExamples,
	#superclass : #Object,
	#category : #'Gt4LlmCore-Examples'
}

{ #category : #examples }
GtLMagritteToolForObjectStorageSlotValueExamples >> retrieveMissingSlotValue [
	<gtExample>
	| objectStorage storedObjectId tool call result model |
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
	self assert: (result isKindOf: GtLMagritteBasedModel).
	model := result model.
	self assert: model isErrorDomainObject.
	self assert: model missingObjectName equals: 'missingSlot'.
	^ call
]

{ #category : #examples }
GtLMagritteToolForObjectStorageSlotValueExamples >> retrieveMissingStoredObjectSlotValue [
	<gtExample>
	| objectStorage tool call result model |
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
	self assert: (result isKindOf: GtLMagritteBasedModel).
	model := result model.
	self assert: model isErrorDomainObject.
	self assert: model missingObjectName equals: 'missing-object-id'.
	^ call
]

{ #category : #examples }
GtLMagritteToolForObjectStorageSlotValueExamples >> retrieveStoredObjectSlotValue [
	<gtExample>
	| objectStorage storedObjectId tool call result model |
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
	self assert: (result isKindOf: GtLMagritteBasedModel).
	model := result model.
	self assert: (model isKindOf: GtLObjectStorageValueResult).
	self assert: model object equals: 'TestObject'.
	self assert: model objectId equals: storedObjectId.
	self assert: model objectValue objectClassName equals: 'ByteString'.
	self assert: model objectValue objectPrintString equals: '''''TestObject'''''.
	^ call
]

{ #category : #examples }
GtLMagritteToolForObjectStorageSlotValueExamples >> retrieveStoredObjectSlotValueWithoutStorage [
	<gtExample>
	| tool call result model |
	tool := GtLMagritteToolForObjectStorageSlotValue new.
	call := GtLFunctionToolCall new.
	call rawArguments: {
		'objectId' -> 'missing'.
		'slotName' -> 'name'
	} asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: (result isKindOf: GtLMagritteBasedModel).
	model := result model.
	self assert: model isErrorDomainObject.
	self assert: model missingModelName equals: 'objectStorage'.
	^ call
]
