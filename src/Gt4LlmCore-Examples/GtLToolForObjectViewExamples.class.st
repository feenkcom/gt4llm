"
Examples for GtLMagritteToolForViewContent.
"
Class {
	#name : #GtLToolForObjectViewExamples,
	#superclass : #Object,
	#category : #'Gt4LlmCore-Examples'
}

{ #category : #examples }
GtLToolForObjectViewExamples >> viewContentForExistingObjectAndView [
	<gtExample>
	| objectStorage tool call result objectId |
	
	objectStorage := GtLObjectStorage new.
	objectId := objectStorage addNewObject: 'Hello'.
	tool := GtLToolForObjectView new.
	call := GtLFunctionToolCall new.
	call rawArguments: {
		'objectId' -> objectId.
		'viewSelector' -> 'gtStringFor:'
	} asDictionary.
	result := tool
		performToolCall: call
		inContext: (GtLToolExecutionContext new 
			objectStorage: objectStorage).
		
	self assert: call tool == tool.
	self assert: (result isKindOf: GtLPhlowViewDomainObject).
	
	self assert: result isErrorDomainObject not.
	self assert: result phlowView notNil.
	self assert: result phlowView title equals: 'String'.
	
	^ call
]

{ #category : #examples }
GtLToolForObjectViewExamples >> viewContentForMissingObjectId [
	<gtExample>
	| tool call result |
	tool := GtLToolForObjectView new.
	call := GtLFunctionToolCall new.
	call rawArguments: {
		'viewSelector' -> 'gtStringFor:'
	} asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: result isErrorDomainObject.
	self assert: result missingArgument equals: 'objectId'.
	^ call
]

{ #category : #examples }
GtLToolForObjectViewExamples >> viewContentForMissingObjectStorage [
	<gtExample>
	| tool call result |
	tool := GtLToolForObjectView new.
	call := GtLFunctionToolCall new.
	call rawArguments: {
		'objectId' -> 'missing'.
		'viewSelector' -> 'gtStringFor:'
	} asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: result isErrorDomainObject.
	self assert: result missingModelName equals: 'objectStorage'.
	^ call
]

{ #category : #examples }
GtLToolForObjectViewExamples >> viewContentForMissingViewSelector [
	<gtExample>
	| tool call result |
	tool := GtLToolForObjectView new.
	call := GtLFunctionToolCall new.
	call rawArguments: {
		'objectId' -> 'missing'
	} asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: result isErrorDomainObject.
	self assert: result missingArgument equals: 'viewSelector'.
	^ call
]

{ #category : #examples }
GtLToolForObjectViewExamples >> viewContentForUnknownObjectId [
	<gtExample>
	| objectStorage tool call result objectId |
	objectStorage := GtLObjectStorage new.
	tool := GtLToolForObjectView new.
	call := GtLFunctionToolCall new.
	objectId := objectStorage addNewObject: 1.
	call rawArguments: {
		'objectId' -> objectId.
		'viewSelector' -> 'gtStringFor:'
	} asDictionary.
	objectStorage clearCache.
	result := tool
		performToolCall: call
		inContext: (GtLToolExecutionContext new objectStorage: objectStorage).
	self assert: call tool == tool.
	self assert: result isErrorDomainObject.
	self assert: result objectName equals: objectId.
	^ call
]
