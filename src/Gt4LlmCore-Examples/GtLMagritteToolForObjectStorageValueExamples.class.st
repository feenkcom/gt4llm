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
	| objectStorage tool domainObject |
	objectStorage := GtLObjectStorage new.
	tool := GtLMagritteToolForObjectStorageValue new.
	domainObject := self
		executeTool: tool
		withArguments: {
			'objectId' -> 'missing-object-id'
		} asDictionary
		inContext: (GtLToolExecutionContext new objectStorage: objectStorage).
	self
		assertMissingObject: domainObject
		withObjectName: 'missing-object-id'
		errorMessage: 'missing-object-id is not found'.
	^ domainObject
]

{ #category : #examples }
GtLMagritteToolForObjectStorageValueExamples >> retrieveStoredObjectValue [
	<gtExample>
	| objectStorage storedObjectId tool domainObject |
	objectStorage := GtLObjectStorage new.
	storedObjectId := objectStorage addNewObject: GtLSerializedObjectValueTestObject exampleInstance reason: 'example object'.
	tool := GtLMagritteToolForObjectStorageValue new.
	domainObject := self
		executeTool: tool
		withArguments: {
			'objectId' -> storedObjectId
		} asDictionary
		inContext: (GtLToolExecutionContext new objectStorage: objectStorage).
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
	| objectStorage tool domainObject |
	objectStorage := GtLObjectStorage new.
	tool := GtLMagritteToolForObjectStorageValue new.
	domainObject := self
		executeTool: tool
		withArguments: { 'objectId' -> '   ' } asDictionary
		inContext: (GtLToolExecutionContext new objectStorage: objectStorage).
	self
		assertMissingArgument: domainObject
		withArgumentName: 'objectId'
		errorMessage: 'Missing argument called objectId'.
	^ domainObject
]

{ #category : #examples }
GtLMagritteToolForObjectStorageValueExamples >> retrieveStoredObjectValueWithMissingObjectId [
	<gtExample>
	| objectStorage tool domainObject |
	objectStorage := GtLObjectStorage new.
	tool := GtLMagritteToolForObjectStorageValue new.
	domainObject := self
		executeTool: tool
		withArguments: Dictionary new
		inContext: (GtLToolExecutionContext new objectStorage: objectStorage).
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
	| tool domainObject |
	tool := GtLMagritteToolForObjectStorageValue new.
	domainObject := self
		executeTool: tool
		withArguments: {
			'objectId' -> 'missing'
		} asDictionary.
	self
		assertMissingInformation: domainObject
		withModelName: 'objectStorage'
		errorMessage: 'Missing objectStorage'.
	^ domainObject
]
