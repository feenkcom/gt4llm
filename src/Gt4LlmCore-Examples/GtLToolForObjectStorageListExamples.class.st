Class {
	#name : #GtLToolForObjectStorageListExamples,
	#superclass : #Object,
	#category : 'Gt4LlmCore-Examples-Tools'
}

{ #category : #examples }
GtLToolForObjectStorageListExamples >> listObjectsWithoutStorage [
	<gtExample>
	| tool call result model |
	tool := GtLToolForObjectStorageList new.
	call := GtLFunctionToolCall new.
	call rawArguments: Dictionary new.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: (result isKindOf: GtLMagritteBasedModel).
	model := result model.
	self assert: model isErrorDomainObject.
	self assert: model missingModelName equals: 'objectStorage'.
	^ call
]

{ #category : #examples }
GtLToolForObjectStorageListExamples >> listObjectsWithStorage [
	<gtExample>
	| objectStorage tool call result model oneItem twoItem |
	objectStorage := GtLObjectStorage new.
	objectStorage addNewObject: 'One' reason: 'first string'.
	objectStorage addNewObject: 2 reason: 'second number'.
	tool := GtLToolForObjectStorageList new.
	call := GtLFunctionToolCall new.
	call rawArguments: Dictionary new.
	result := tool
		performToolCall: call
		inContext: (GtLToolExecutionContext new objectStorage: objectStorage).
	self assert: call tool == tool.
	self assert: (result isKindOf: GtLMagritteBasedModel).
	model := result model.
	self assert: model items size equals: 2.
	self assert: (model items collect: #objectValue) asSet equals: (Set with: 'One' with: 2).
	oneItem := model items detect: [ :each | each objectValue = 'One' ].
	twoItem := model items detect: [ :each | each objectValue = 2 ].
	self assert: oneItem reason equals: 'first string'.
	self assert: twoItem reason equals: 'second number'.
	^ call
]
