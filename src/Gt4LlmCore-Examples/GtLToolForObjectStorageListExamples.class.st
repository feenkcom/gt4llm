Class {
	#name : #GtLToolForObjectStorageListExamples,
	#superclass : #Object,
	#category : #'Gt4LlmCore-Examples'
}

{ #category : #examples }
GtLToolForObjectStorageListExamples >> listObjectsWithStorage [
	<gtExample>
	| objectStorage tool call result model |
	objectStorage := GtLObjectStorage new.
	objectStorage addNewObject: 'One'.
	objectStorage addNewObject: 2.
	tool := GtLToolForObjectStorageList new.
	call := GtLFunctionToolCall new.
	call rawArguments: Dictionary new.
	result := tool
		performToolCall: call
		inContext: (GtLToolExecutionContext new objectStorage: objectStorage).
	self assert: call tool == tool.
	self assert: (result isKindOf: GtLMagritteInputModel).
	model := result model.
	self assert: model items size equals: 2.
	self assert: (model items collect: #objectValue) asSet equals: (Set with: 'One' with: 2).
	^ call
]

{ #category : #examples }
GtLToolForObjectStorageListExamples >> listObjectsWithoutStorage [
	<gtExample>
	| tool call result model |
	tool := GtLToolForObjectStorageList new.
	call := GtLFunctionToolCall new.
	call rawArguments: Dictionary new.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: (result isKindOf: GtLMagritteInputModel).
	model := result model.
	self assert: model isErrorDomainObject.
	self assert: model missingModelName equals: 'objectStorage'.
	^ call
]
