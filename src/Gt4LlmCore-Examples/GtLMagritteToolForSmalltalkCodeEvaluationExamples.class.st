"
Examples for GtLMagritteToolForSmalltalkCodeEvaluation.
"
Class {
	#name : #GtLMagritteToolForSmalltalkCodeEvaluationExamples,
	#superclass : #Object,
	#category : #'Gt4LlmCore-Examples-Tools'
}

{ #category : #examples }
GtLMagritteToolForSmalltalkCodeEvaluationExamples >> emptyCodeArgument [
	<gtExample>
	| tool call result model |
	tool := GtLMagritteToolForSmalltalkCodeEvaluation new.
	call := GtLFunctionToolCall new.
	call rawArguments: {
		'code' -> '   '.
		'bindings' -> #()
	} asDictionary.
	result := tool performToolCall: call.
	
	self assert: call tool == tool.
	self assert: (result isKindOf: GtLMagritteBasedModel).
	
	model := result model.
	self assert: model isErrorDomainObject.
	self assert: (model isKindOf: GtLMissingArgumentDomainObject).
	self assert: model missingArgument equals: 'code'.
	
	^ call
]

{ #category : #examples }
GtLMagritteToolForSmalltalkCodeEvaluationExamples >> executeReturningObjectWithSlots [
	<gtExample>
	"Test execution that returns an object with slots and views."
	| objectStorage tool call result model objectValue |
	objectStorage := GtLObjectStorage new.
	tool := GtLMagritteToolForSmalltalkCodeEvaluation new.
	call := GtLFunctionToolCall new.
	call rawArguments: {
		'code' -> 'GtLSerializedObjectValueTestObject exampleInstance'.
		'bindings' -> #()
	} asDictionary.
	result := tool
		performToolCall: call
		inContext: (GtLToolExecutionContext new objectStorage: objectStorage).
	
	self assert: call tool == tool.
	self assert: (result isKindOf: GtLMagritteBasedModel).
	
	model := result model.
	self assert: (model isKindOf: GtLSmalltalkCodeEvaluationResult).
	self assert: (model object isKindOf: GtLSerializedObjectValueTestObject).
	self assert: model object name equals: 'TestObject'.
	self assert: model object count equals: 42.
	self assert: model object items equals: #('apple' 'banana' 'cherry').
	
	"Verify the serialized object value"
	objectValue := model objectValue.
	self assert: objectValue objectClassName equals: 'GtLSerializedObjectValueTestObject'.
	self assert: objectValue superclassName equals: 'Object'.
	self assert: objectValue packageName equals: 'Gt4LlmCore-Examples'.
	self assert: (objectValue objectPrintString includesSubstring: 'TestObject').
	
	"Verify views are captured"
	self assert: objectValue phlowViews isNotEmpty.
	self assert: (objectValue phlowViews anySatisfy: [ :v | v title = 'Details' ]).
	self assert: (objectValue phlowViews anySatisfy: [ :v | v title = 'Items' ]).
	
	"Verify slots are captured"
	self assert: objectValue allInstanceSlots size equals: 3.
	self assert: (objectValue allInstanceSlots anySatisfy: [ :s | 
		s name = 'name' and: [ s valueClassName = 'ByteString' ] ]).
	self assert: (objectValue allInstanceSlots anySatisfy: [ :s | 
		s name = 'count' and: [ s valuePrintString = '42' ] ]).
	
	"Verify object was stored"
	self assert: model objectId isNotEmpty.
	self assert: (objectStorage objectAt: model objectId) == model object.
	
	^ call
]

{ #category : #examples }
GtLMagritteToolForSmalltalkCodeEvaluationExamples >> executeReturningObjectWithSlotsSerialization [
	<gtExample>
	"Test that the result serializes correctly to JSON."
	| call result jsonObject objectValue slots |
	call := self executeReturningObjectWithSlots.
	result := call result.
	jsonObject := GtMagritteJSONDataExporter exportObject: result model.
	
	"Verify top-level structure"
	self assert: (jsonObject at: 'code') equals: 'GtLSerializedObjectValueTestObject exampleInstance'.
	self assert: (jsonObject at: 'objectId') isNotEmpty.
	
	"Verify object value structure"
	objectValue := jsonObject at: 'objectValue'.
	self assert: (objectValue at: 'objectClassName') equals: 'GtLSerializedObjectValueTestObject'.
	self assert: (objectValue at: 'superclassName') equals: 'Object'.
	self assert: (objectValue at: 'packageName') equals: 'Gt4LlmCore-Examples'.
	
	"Verify views are serialized"
	self assert: (objectValue at: 'phlowViews') isNotEmpty.
	self assert: ((objectValue at: 'phlowViews') anySatisfy: [ :v | 
		(v at: 'title') = 'Details' ]).
	
	"Verify slots are serialized with correct keys"
	slots := objectValue at: 'allInstanceSlots'.
	self assert: slots size equals: 3.
	self assert: (slots anySatisfy: [ :s | 
		(s at: 'name') = 'name' 
			and: [ (s at: 'valueClassName') = 'ByteString'
				and: [ (s at: 'valuePrintString') = 'TestObject' ] ] ]).
	self assert: (slots anySatisfy: [ :s | 
		(s at: 'name') = 'count' 
			and: [ (s at: 'valueClassName') = 'SmallInteger'
				and: [ (s at: 'valuePrintString') = '42' ] ] ]).
	
	^ jsonObject
]

{ #category : #examples }
GtLMagritteToolForSmalltalkCodeEvaluationExamples >> executeSimpleDoIt [
	<gtExample>
	| objectStorage tool call result model |
	objectStorage := GtLObjectStorage new.
	tool := GtLMagritteToolForSmalltalkCodeEvaluation new.
	call := GtLFunctionToolCall new.
	call rawArguments: {
		'code' -> '1 + 2'.
		'bindings' -> #()
	} asDictionary.
	result := tool
		performToolCall: call
		inContext: (GtLToolExecutionContext new objectStorage: objectStorage).
	
	self assert: call tool == tool.
	self assert: (result isKindOf: GtLMagritteBasedModel).
	
	model := result model.
	self assert: (model isKindOf: GtLSmalltalkCodeEvaluationResult).
	self assert: model object equals: 3.
	self assert: model code equals: '1 + 2'.
	self assert: model objectValue objectClassName equals: 'SmallInteger'.
	self assert: model objectValue objectPrintString equals: '3'.
	self assert: model objectId isNotEmpty.
	
	self assert: objectStorage objectCount equals: 1.
	self assert: (objectStorage objectAt: objectStorage objectIds first) equals: 3.
	
	^ call
]

{ #category : #examples }
GtLMagritteToolForSmalltalkCodeEvaluationExamples >> executeSimpleDoItWithoutObjectStorage [
	<gtExample>
	| tool call result model |
	tool := GtLMagritteToolForSmalltalkCodeEvaluation new.
	call := GtLFunctionToolCall new.
	call rawArguments: {
		'code' -> '1 + 2'.
		'bindings' -> #()
	} asDictionary.
	result := tool performToolCall: call.
	
	self assert: call tool == tool.
	self assert: (result isKindOf: GtLMagritteBasedModel).
	
	model := result model.
	self assert: (model isKindOf: GtLSmalltalkCodeEvaluationResult).
	self assert: model object equals: 3.
	self assert: model code equals: '1 + 2'.
	self assert: model objectId equals: ''.
	
	^ call
]

{ #category : #'examples - bindings errors' }
GtLMagritteToolForSmalltalkCodeEvaluationExamples >> executeWithBindingEmptyName [
	<gtExample>
	"Test that a binding with empty name is handled."
	| objectStorage tool call result model bindingObjectId |
	objectStorage := GtLObjectStorage new.
	bindingObjectId := objectStorage addNewObject: 40.
	
	tool := GtLMagritteToolForSmalltalkCodeEvaluation new.
	call := GtLFunctionToolCall new.
	call rawArguments: {
		'code' -> 'value + 2'.
		'bindings' -> {
			{ 'name' -> ''. 'objectId' -> bindingObjectId } asDictionary
		} asArray
	} asDictionary.
	result := tool
		performToolCall: call
		inContext: (GtLToolExecutionContext new objectStorage: objectStorage).
	
	self assert: (result isKindOf: GtLMagritteBasedModel).
	model := result model.
	
	"Should fail because binding name is empty - can't create valid symbol"
	self assert: (model isKindOf: GtLSmalltalkCodeEvaluationExceptionResult).
	self assert: model isErrorDomainObject.
	
	^ call
]

{ #category : #'examples - bindings edge cases' }
GtLMagritteToolForSmalltalkCodeEvaluationExamples >> executeWithBindingEmptyObjectId [
	<gtExample>
	"Test that a binding with empty objectId is handled."
	| objectStorage tool call result model |
	objectStorage := GtLObjectStorage new.
	
	tool := GtLMagritteToolForSmalltalkCodeEvaluation new.
	call := GtLFunctionToolCall new.
	call rawArguments: {
		'code' -> 'value + 2'.
		'bindings' -> {
			{ 'name' -> 'value'. 'objectId' -> '' } asDictionary
		} asArray
	} asDictionary.
	result := tool
		performToolCall: call
		inContext: (GtLToolExecutionContext new objectStorage: objectStorage).
	
	self assert: (result isKindOf: GtLMagritteBasedModel).
	model := result model.
	
	"Should fail because objectId is empty - caught early in validation"
	self assert: (model isKindOf: GtLMissingDomainObject).
	self assert: model isErrorDomainObject.
	self assert: model objectName equals: ''.
	
	^ call
]

{ #category : #'examples - bindings edge cases' }
GtLMagritteToolForSmalltalkCodeEvaluationExamples >> executeWithBindingMissingName [
	<gtExample>
	"Test that a binding with missing name is handled - Magritte returns empty string for missing name."
	| objectStorage tool call result model bindingObjectId |
	objectStorage := GtLObjectStorage new.
	bindingObjectId := objectStorage addNewObject: 40.
	
	tool := GtLMagritteToolForSmalltalkCodeEvaluation new.
	call := GtLFunctionToolCall new.
	call rawArguments: {
		'code' -> 'value + 2'.
		'bindings' -> {
			{ 'objectId' -> bindingObjectId } asDictionary  "missing 'name'"
		} asArray
	} asDictionary.
	result := tool
		performToolCall: call
		inContext: (GtLToolExecutionContext new objectStorage: objectStorage).
	
	self assert: (result isKindOf: GtLMagritteBasedModel).
	model := result model.
	
	"Should fail - either validation error or compilation error"
	self assert: model isErrorDomainObject.
	
	^ call
]

{ #category : #'examples - bindings edge cases' }
GtLMagritteToolForSmalltalkCodeEvaluationExamples >> executeWithBindingMissingObjectId [
	<gtExample>
	"Test that a binding with missing objectId is handled - Magritte validation catches null."
	| objectStorage tool call result model |
	objectStorage := GtLObjectStorage new.
	
	tool := GtLMagritteToolForSmalltalkCodeEvaluation new.
	call := GtLFunctionToolCall new.
	call rawArguments: {
		'code' -> 'value + 2'.
		'bindings' -> {
			{ 'name' -> 'value' } asDictionary  "missing 'objectId'"
		} asArray
	} asDictionary.
	result := tool
		performToolCall: call
		inContext: (GtLToolExecutionContext new objectStorage: objectStorage).
	
	self assert: (result isKindOf: GtLMagritteBasedModel).
	model := result model.
	
	"Should fail - Magritte validation catches null objectId"
	self assert: model isErrorDomainObject.
	
	^ call
]

{ #category : #'examples - bindings edge cases' }
GtLMagritteToolForSmalltalkCodeEvaluationExamples >> executeWithBindingNilName [
	<gtExample>
	"Test that a binding with nil name is handled - Magritte validation catches null for required string."
	| objectStorage tool call result model bindingObjectId |
	objectStorage := GtLObjectStorage new.
	bindingObjectId := objectStorage addNewObject: 40.
	
	tool := GtLMagritteToolForSmalltalkCodeEvaluation new.
	call := GtLFunctionToolCall new.
	call rawArguments: {
		'code' -> 'value + 2'.
		'bindings' -> {
			{ 'name' -> nil. 'objectId' -> bindingObjectId } asDictionary
		} asArray
	} asDictionary.
	result := tool
		performToolCall: call
		inContext: (GtLToolExecutionContext new objectStorage: objectStorage).
	
	self assert: (result isKindOf: GtLMagritteBasedModel).
	model := result model.
	
	"Magritte validation catches null name - it's an error"
	self assert: model isErrorDomainObject.
	
	^ call
]

{ #category : #'examples - bindings edge cases' }
GtLMagritteToolForSmalltalkCodeEvaluationExamples >> executeWithBindingNilObjectId [
	<gtExample>
	"Test that a binding with nil objectId is handled - Magritte validation catches this."
	| objectStorage tool call result model |
	objectStorage := GtLObjectStorage new.
	
	tool := GtLMagritteToolForSmalltalkCodeEvaluation new.
	call := GtLFunctionToolCall new.
	call rawArguments: {
		'code' -> 'value + 2'.
		'bindings' -> {
			{ 'name' -> 'value'. 'objectId' -> nil } asDictionary
		} asArray
	} asDictionary.
	result := tool
		performToolCall: call
		inContext: (GtLToolExecutionContext new objectStorage: objectStorage).
	
	self assert: (result isKindOf: GtLMagritteBasedModel).
	model := result model.
	
	"Magritte validation catches null values for required fields"
	self assert: model isErrorDomainObject.
	
	^ call
]

{ #category : #examples }
GtLMagritteToolForSmalltalkCodeEvaluationExamples >> executeWithBindings [
	<gtExample>
	| objectStorage tool call result model bindingObjectId resultObjectId |
	objectStorage := GtLObjectStorage new.
	bindingObjectId := objectStorage addNewObject: 40.
	
	tool := GtLMagritteToolForSmalltalkCodeEvaluation new.
	call := GtLFunctionToolCall new.
	call rawArguments: {
		'code' -> 'value + 2'.
		'bindings' -> {
			{ 'name' -> 'value'. 'objectId' -> bindingObjectId } asDictionary
		} asArray
	} asDictionary.
	result := tool
		performToolCall: call
		inContext: (GtLToolExecutionContext new objectStorage: objectStorage).
	
	self assert: call tool == tool.
	self assert: (result isKindOf: GtLMagritteBasedModel).
	
	model := result model.
	self assert: (model isKindOf: GtLSmalltalkCodeEvaluationResult).
	self assert: model object equals: 42.
	
	resultObjectId := model objectId.
	self assert: resultObjectId isNotEmpty.
	self assert: resultObjectId ~= bindingObjectId.
	self assert: (objectStorage objectAt: bindingObjectId) equals: 40.
	self assert: (objectStorage objectAt: resultObjectId) equals: 42.
	
	^ call
]

{ #category : #examples }
GtLMagritteToolForSmalltalkCodeEvaluationExamples >> executeWithBindingsMissingObjectStorage [
	<gtExample>
	| tool call result model |
	tool := GtLMagritteToolForSmalltalkCodeEvaluation new.
	call := GtLFunctionToolCall new.
	call rawArguments: {
		'code' -> 'value + 2'.
		'bindings' -> {
			{ 'name' -> 'value'. 'objectId' -> 'missing' } asDictionary
		} asArray
	} asDictionary.
	result := tool performToolCall: call.
	
	self assert: call tool == tool.
	self assert: (result isKindOf: GtLMagritteBasedModel).
	
	model := result model.
	self assert: model isErrorDomainObject.
	self assert: model missingModelName equals: 'objectStorage'.
	
	^ call
]

{ #category : #examples }
GtLMagritteToolForSmalltalkCodeEvaluationExamples >> executeWithError [
	<gtExample>
	| tool call result model |
	tool := GtLMagritteToolForSmalltalkCodeEvaluation new.
	call := GtLFunctionToolCall new.
	call rawArguments: {
		'code' -> '1 / 0'.
		'bindings' -> #()
	} asDictionary.
	result := tool performToolCall: call.
	
	self assert: call tool == tool.
	self assert: (result isKindOf: GtLMagritteBasedModel).
	
	model := result model.
	self assert: (model isKindOf: GtLSmalltalkCodeEvaluationExceptionResult).
	self assert: model isErrorDomainObject.
	self assert: model code equals: '1 / 0'.
	self assert: (model whatFailed beginsWith: 'Error while evaluating smalltalk code').
	self assert: (model errorMessage includesSubstring: 'ZeroDivide').
	self assert: model errorClassName equals: 'ZeroDivide'.
	self assert: model exception isNotNil.
	
	^ call
]

{ #category : #examples }
GtLMagritteToolForSmalltalkCodeEvaluationExamples >> missingCodeArgument [
	<gtExample>
	| tool call result model |
	tool := GtLMagritteToolForSmalltalkCodeEvaluation new.
	call := GtLFunctionToolCall new.
	call rawArguments: {
		'bindings' -> #()
	} asDictionary.
	result := tool performToolCall: call.
	
	self assert: call tool == tool.
	self assert: (result isKindOf: GtLMagritteBasedModel).
	
	model := result model.
	self assert: model isErrorDomainObject.
	self assert: (model isKindOf: GtLMissingRequiredPropertiesDomainObject).
	self assert: model missingPropertyNames equals: #('code').
	
	^ call
]
