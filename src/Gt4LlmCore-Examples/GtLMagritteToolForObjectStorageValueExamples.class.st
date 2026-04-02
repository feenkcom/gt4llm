"
Examples for GtLMagritteToolForObjectStorageValue.
"
Class {
	#name : #GtLMagritteToolForObjectStorageValueExamples,
	#superclass : #Object,
	#traits : 'TGtLInvalidInputDataAssertions',
	#classTraits : 'TGtLInvalidInputDataAssertions classTrait',
	#category : 'Gt4LlmCore-Examples-Tools'
}

{ #category : #examples }
GtLMagritteToolForObjectStorageValueExamples >> retrieveMissingStoredObjectValue [
	<gtExample>
	| objectStorage tool call result domainObject |
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
	self assert: (result isKindOf: GTLDataViewWrapperModel).
	domainObject := result targetObject.
	self
		assertMissingObject: domainObject
		withObjectName: 'missing-object-id'
		errorMessage: 'missing-object-id is not found'.
	^ domainObject
]

{ #category : #examples }
GtLMagritteToolForObjectStorageValueExamples >> retrieveStoredObjectValue [
	<gtExample>
	| objectStorage storedObjectId tool call result domainObject |
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
	self assert: (result isKindOf: GTLDataViewWrapperModel).
	domainObject := result targetObject.
	self assert: (domainObject isKindOf: GtLObjectStorageValueResult).
	self assert: domainObject object == (objectStorage objectAt: storedObjectId).
	self assert: domainObject objectId equals: storedObjectId.
	self assert: domainObject objectValue objectClassName equals: 'GtLSerializedObjectValueTestObject'.
	self assert: (domainObject objectValue phlowViews anySatisfy: [ :each | each title = 'Details' ]).
	self assert: domainObject objectValue allInstanceSlots size equals: 3.
	^ domainObject
]

{ #category : #examples }
GtLMagritteToolForObjectStorageValueExamples >> retrieveStoredObjectValueWithEmptyObjectId [
	<gtExample>
	| objectStorage tool call result domainObject |
	objectStorage := GtLObjectStorage new.
	tool := GtLMagritteToolForObjectStorageValue new.
	call := GtLFunctionToolCall new.
	call rawArguments: { 'objectId' -> '   ' } asDictionary.
	result := tool
		performToolCall: call
		inContext: (GtLToolExecutionContext new objectStorage: objectStorage).
	self assert: call tool == tool.
	self assert: (result isKindOf: GTLDataViewWrapperModel).
	domainObject := result targetObject.
	self
		assertMissingArgument: domainObject
		withArgumentName: 'objectId'
		errorMessage: 'Missing argument called objectId'.
	^ domainObject
]

{ #category : #examples }
GtLMagritteToolForObjectStorageValueExamples >> retrieveStoredObjectValueWithMissingObjectId [
	<gtExample>
	| objectStorage tool call result domainObject |
	objectStorage := GtLObjectStorage new.
	tool := GtLMagritteToolForObjectStorageValue new.
	call := GtLFunctionToolCall new.
	call rawArguments: Dictionary new.
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
GtLMagritteToolForObjectStorageValueExamples >> retrieveStoredObjectValueWithoutStorage [
	<gtExample>
	| tool call result domainObject |
	tool := GtLMagritteToolForObjectStorageValue new.
	call := GtLFunctionToolCall new.
	call rawArguments: {
		'objectId' -> 'missing'
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
