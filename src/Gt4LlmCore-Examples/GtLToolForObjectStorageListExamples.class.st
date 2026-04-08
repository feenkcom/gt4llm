Class {
	#name : #GtLToolForObjectStorageListExamples,
	#superclass : #GtLAbstractMagritteFunctionToolExamples,
	#category : #'Gt4LlmCore-Examples-Tools'
}

{ #category : #examples }
GtLToolForObjectStorageListExamples >> listEmptyObjectStorage [
	<gtExample>
	| objectStorage tool call result domainObject |
	objectStorage := GtLObjectStorage new.
	tool := GtLToolForObjectStorageList new.
	call := GtLFunctionToolCall new.
	call rawArguments: Dictionary new.
	result := tool
		performToolCall: call
		inContext: (GtLToolExecutionContext new objectStorage: objectStorage).
	self assert: call tool == tool.
	self assert: (result isKindOf: GTLDataViewWrapperModel).
	domainObject := result targetObject.
	self assert: (domainObject isKindOf: GtLObjectStorageItems).
	self assert: domainObject items isEmpty.
	^ domainObject
]

{ #category : #examples }
GtLToolForObjectStorageListExamples >> listObjectsWithStorage [
	<gtExample>
	| objectStorage tool call result domainObject oneItem twoItem |
	objectStorage := GtLObjectStorage new.
	objectStorage addNewObject: 'One' reason: (GtLStoredObjectStringReason text: 'first string').
	objectStorage addNewObject: 2 reason: (GtLStoredObjectStringReason text: 'second number').
	tool := GtLToolForObjectStorageList new.
	call := GtLFunctionToolCall new.
	call rawArguments: Dictionary new.
	result := tool
		performToolCall: call
		inContext: (GtLToolExecutionContext new objectStorage: objectStorage).
	self assert: call tool == tool.
	self assert: (result isKindOf: GTLDataViewWrapperModel).
	domainObject := result targetObject.
	self assert: (domainObject isKindOf: GtLObjectStorageItems).
	self assert: domainObject items size equals: 2.
	self assert: (domainObject items collect: #objectValue) asSet equals: (Set with: 'One' with: 2).
	oneItem := domainObject items detect: [ :each | each objectValue = 'One' ].
	twoItem := domainObject items detect: [ :each | each objectValue = 2 ].
	self assert: oneItem reasonString equals: 'first string'.
	self assert: twoItem reasonString equals: 'second number'.
	^ domainObject
]

{ #category : #examples }
GtLToolForObjectStorageListExamples >> listObjectsWithoutStorage [
	<gtExample>
	| tool call result domainObject |
	tool := GtLToolForObjectStorageList new.
	call := GtLFunctionToolCall new.
	call rawArguments: Dictionary new.
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
