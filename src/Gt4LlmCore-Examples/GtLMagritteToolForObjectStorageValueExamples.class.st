"
Examples for GtLMagritteToolForObjectStorageValue.
"
Class {
	#name : #GtLMagritteToolForObjectStorageValueExamples,
	#superclass : #Object,
	#category : #'Gt4LlmCore-Examples'
}

{ #category : #examples }
GtLMagritteToolForObjectStorageValueExamples >> retrieveMissingStoredObjectValue [
	<gtExample>
	| objectStorage tool call result model |
	objectStorage := GtLObjectStorage new.
	tool := GtLMagritteToolForObjectStorageValue new.
	call := GtLFunctionToolCall new.
	call rawArguments: {
		'objectId' -> 'missing-object-id'
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
GtLMagritteToolForObjectStorageValueExamples >> retrieveStoredObjectValue [
	<gtExample>
	| objectStorage storedObjectId tool call result model |
	objectStorage := GtLObjectStorage new.
	storedObjectId := objectStorage addNewObject: GtLSerializedObjectValueTestObject exampleInstance reason: 'example object'.
	tool := GtLMagritteToolForObjectStorageValue new.
	call := GtLFunctionToolCall new.
	call rawArguments: {
		'objectId' -> storedObjectId
	} asDictionary.
	result := tool
		performToolCall: call
		inContext: (GtLToolExecutionContext new objectStorage: objectStorage).
	self assert: call tool == tool.
	self assert: (result isKindOf: GtLMagritteBasedModel).
	model := result model.
	self assert: (model isKindOf: GtLObjectStorageValueResult).
	self assert: model object == (objectStorage objectAt: storedObjectId).
	self assert: model objectId equals: storedObjectId.
	self assert: model objectValue objectClassName equals: 'GtLSerializedObjectValueTestObject'.
	self assert: (model objectValue phlowViews anySatisfy: [ :each | each title = 'Details' ]).
	self assert: model objectValue allInstanceSlots size equals: 3.
	^ call
]

{ #category : #examples }
GtLMagritteToolForObjectStorageValueExamples >> retrieveStoredObjectValueWithoutStorage [
	<gtExample>
	| tool call result model |
	tool := GtLMagritteToolForObjectStorageValue new.
	call := GtLFunctionToolCall new.
	call rawArguments: {
		'objectId' -> 'missing'
	} asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: (result isKindOf: GtLMagritteBasedModel).
	model := result model.
	self assert: model isErrorDomainObject.
	self assert: model missingModelName equals: 'objectStorage'.
	^ call
]
