"
Examples for GtLMagritteToolForExampleMethodRun.
"
Class {
	#name : #GtLMagritteToolForExampleMethodRunExamples,
	#superclass : #Object,
	#traits : 'TGtLInvalidInputDataAssertions',
	#classTraits : 'TGtLInvalidInputDataAssertions classTrait',
	#category : 'Gt4LlmCore-Examples-Tools'
}

{ #category : #examples }
GtLMagritteToolForExampleMethodRunExamples >> exampleRunError [
	<gtExample>
	| tool call result targetObject |
	tool := GtLToolForExampleMethodRun new.
	call := GtLFunctionToolCall new.
	call rawArguments: {
		'exampleReference' -> {
			'exampleClassName' -> 'GtLExampleRunDummyExamples'.
			'methodName' -> 'errorExample'.
			'classSide' -> false
		} asDictionary
	} asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: (result isKindOf: GTLDataViewWrapperModel).
	targetObject := result targetObject.
	self assert: (targetObject isKindOf: GtLExampleWithResultDomainObject).
	self assert: targetObject isErrorResult.
	^ call
]

{ #category : #examples }
GtLMagritteToolForExampleMethodRunExamples >> exampleRunFailure [
	<gtExample>
	| tool call result targetObject |
	tool := GtLToolForExampleMethodRun new.
	call := GtLFunctionToolCall new.
	call rawArguments: {
		'exampleReference' -> {
			'exampleClassName' -> 'GtLExampleRunDummyExamples'.
			'methodName' -> 'failingExample'.
			'classSide' -> false
		} asDictionary
	} asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: (result isKindOf: GTLDataViewWrapperModel).
	
	targetObject := result targetObject.
	self assert: (targetObject isKindOf: GtLExampleWithResultDomainObject).
	self assert: targetObject isFailureResult.
	^ call
]

{ #category : #examples }
GtLMagritteToolForExampleMethodRunExamples >> exampleRunForMissingExampleClassName [
	<gtExample>
	| tool call result targetObject |
	tool := GtLToolForExampleMethodRun new.
	call := GtLFunctionToolCall new.
	call rawArguments: {
		'exampleReference' -> {
			'methodName' -> 'someMethod'.
			'classSide' -> false
		} asDictionary
	} asDictionary.
	result := tool performToolCall: call.
	
	self assert: call tool == tool.
	self assert: (result isKindOf: GTLDataViewWrapperModel).
	
	targetObject := result targetObject.
	self
		assertMissingRequiredProperties: targetObject
		withPropertyNames: #('exampleClassName')
		path: #('exampleReference')
		errorMessage: '@[exampleReference] required properties missing [exampleClassName]'.
	
	^ call
]

{ #category : #examples }
GtLMagritteToolForExampleMethodRunExamples >> exampleRunForMissingExampleReference [
	<gtExample>
	| tool call result targetObject |
	tool := GtLToolForExampleMethodRun new.
	call := GtLFunctionToolCall new.
	call rawArguments: Dictionary new.
	result := tool performToolCall: call.
	
	self assert: call tool == tool.
	self assert: (result isKindOf: GTLDataViewWrapperModel).
	
	targetObject := result targetObject.
	self
		assertMissingRequiredProperties: targetObject
		withPropertyNames: #('exampleReference')
		path: #(nil)
		errorMessage: 'required properties missing [exampleReference]'.
	
	^ call
]

{ #category : #examples }
GtLMagritteToolForExampleMethodRunExamples >> exampleRunForMissingMethodName [
	<gtExample>
	| tool call result targetObject |
	tool := GtLToolForExampleMethodRun new.
	call := GtLFunctionToolCall new.
	call rawArguments: {
		'exampleReference' -> {
			'exampleClassName' -> 'GtTMoneyExamples'.
			'classSide' -> false
		} asDictionary
	} asDictionary.
	result := tool performToolCall: call.
	
	self assert: call tool == tool.
	self assert: (result isKindOf: GTLDataViewWrapperModel).
	
	targetObject := result targetObject.
	self
		assertMissingRequiredProperties: targetObject
		withPropertyNames: #('methodName')
		path: #('exampleReference')
		errorMessage: '@[exampleReference] required properties missing [methodName]'.
	
	^ call
]

{ #category : #examples }
GtLMagritteToolForExampleMethodRunExamples >> exampleRunForNilExampleClassName [
	<gtExample>
	| tool call result targetObject |
	tool := GtLToolForExampleMethodRun new.
	call := GtLFunctionToolCall new.
	call rawArguments: {
		'exampleReference' -> {
			'exampleClassName' -> nil.
			'methodName' -> 'someMethod'.
			'classSide' -> false
		} asDictionary
	} asDictionary.
	result := tool performToolCall: call.
	
	self assert: call tool == tool.
	self assert: (result isKindOf: GTLDataViewWrapperModel).
	
	targetObject := result targetObject.
	self
		assertJSONSchemaValidationError: targetObject
		withPath: #('exampleReference' 'exampleClassName')
		errorMessage: '@[exampleReference/exampleClassName] string expected'.
	
	^ call
]

{ #category : #examples }
GtLMagritteToolForExampleMethodRunExamples >> exampleRunForNilMethodName [
	<gtExample>
	| tool call result targetObject |
	tool := GtLToolForExampleMethodRun new.
	call := GtLFunctionToolCall new.
	call rawArguments: {
		'exampleReference' -> {
			'exampleClassName' -> 'GtTMoneyExamples'.
			'methodName' -> nil.
			'classSide' -> false
		} asDictionary
	} asDictionary.
	result := tool performToolCall: call.
	
	self assert: call tool == tool.
	self assert: (result isKindOf: GTLDataViewWrapperModel).
	
	targetObject := result targetObject.
	self
		assertJSONSchemaValidationError: targetObject
		withPath: #('exampleReference' 'methodName')
		errorMessage: '@[exampleReference/methodName] string expected'.
	
	^ call
]

{ #category : #examples }
GtLMagritteToolForExampleMethodRunExamples >> exampleRunForNonExampleMethod [
	<gtExample>
	| tool call result |
	tool := GtLToolForExampleMethodRun new.
	call := GtLFunctionToolCall new.
	call rawArguments: {
		'exampleReference' -> {
			'exampleClassName' -> 'GtLExampleRunDummyExamples'.
			'methodName' -> 'regularMethod'.
			'classSide' -> false
		} asDictionary
	} asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: (result isKindOf: GTLDataViewWrapperModel).
	self assert: (result targetObject isKindOf: GtLMethodIsNotExampleDomainObject).
	self
		assert: result targetObject method name
		equals: 'GtLExampleRunDummyExamples>>#regularMethod'.
	^ call
]

{ #category : #examples }
GtLMagritteToolForExampleMethodRunExamples >> exampleRunForUnknownClass [
	<gtExample>
	| tool call result targetObject |
	tool := GtLToolForExampleMethodRun new.
	call := GtLFunctionToolCall new.
	call rawArguments: {
		'exampleReference' -> {
			'exampleClassName' -> 'NonExistentClassXYZ123'.
			'methodName' -> 'someMethod'.
			'classSide' -> false
		} asDictionary
	} asDictionary.
	result := tool performToolCall: call.
	
	self assert: call tool == tool.
	self assert: (result isKindOf: GTLDataViewWrapperModel).
	
	targetObject := result targetObject.
	self
		assertMissingObject: targetObject
		withObjectName: 'NonExistentClassXYZ123'
		errorMessage: 'NonExistentClassXYZ123 is not found'.
	
	^ call
]

{ #category : #examples }
GtLMagritteToolForExampleMethodRunExamples >> exampleRunForUnknownMethod [
	<gtExample>
	| tool call result targetObject |
	tool := GtLToolForExampleMethodRun new.
	call := GtLFunctionToolCall new.
	call rawArguments: {
		'exampleReference' -> {
			'exampleClassName' -> 'GtTMoneyExamples'.
			'methodName' -> 'nonExistentMethodXYZ123'.
			'classSide' -> false
		} asDictionary
	} asDictionary.
	result := tool performToolCall: call.
	
	self assert: call tool == tool.
	self assert: (result isKindOf: GTLDataViewWrapperModel).
	
	targetObject := result targetObject.
	self
		assertMissingObject: targetObject
		withObjectName: 'GtTMoneyExamples>>#nonExistentMethodXYZ123'
		errorMessage: 'GtTMoneyExamples>>#nonExistentMethodXYZ123 is not found'.
	
	^ call
]

{ #category : #examples }
GtLMagritteToolForExampleMethodRunExamples >> exampleRunSuccess [
	<gtExample>
	| tool call result targetObject |
	tool := GtLToolForExampleMethodRun new.
	call := GtLFunctionToolCall new.
	call rawArguments: {
		'exampleReference' -> {
			'exampleClassName' -> 'GtTMoneyExamples'.
			'methodName' -> 'fortyTwoEuros'.
			'classSide' -> false
		} asDictionary
	} asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: call arguments size equals: 1.
	self assert: ((call arguments at: 'exampleReference') isKindOf: GtLExampleReference).
	self assert: (result isKindOf: GTLDataViewWrapperModel).
	
	targetObject := result targetObject.
	self assert: (targetObject isKindOf: GtLExampleWithResultDomainObject).
	self assert: targetObject isSuccessResult.
	self assert: targetObject objectId isNil.
	^ call
]

{ #category : #examples }
GtLMagritteToolForExampleMethodRunExamples >> exampleRunSuccessStoresObjectId [
	<gtExample>
	| objectStorage tool call result targetObject objectId storedObject |
	objectStorage := GtLObjectStorage new.
	tool := GtLToolForExampleMethodRun new.
	call := GtLFunctionToolCall new.
	call rawArguments: {
		'exampleReference' -> {
			'exampleClassName' -> 'GtLExampleRunDummyExamples'.
			'methodName' -> 'successfulExample'.
			'classSide' -> false
		} asDictionary
	} asDictionary.
	result := tool
		performToolCall: call
		inContext: (GtLToolExecutionContext new objectStorage: objectStorage).
	self assert: call tool == tool.
	self assert: (result isKindOf: GTLDataViewWrapperModel).
	targetObject := result targetObject.
	
	self assert: (targetObject isKindOf: GtLExampleWithResultDomainObject).
	self assert: targetObject isSuccessResult.
	objectId := targetObject objectId.
	self assert: objectId isString.
	self assert: (objectStorage objectAt: objectId) equals: 42.
	storedObject := objectStorage storedObjectAt: objectId.
	self assert: storedObject reason class equals: GtLStoredObjectExampleMethodReason.
	
	^ call
]
