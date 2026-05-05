"
Examples for GtLMagritteToolForExampleMethodRun.
"
Class {
	#name : #GtLToolForExampleMethodRunExamples,
	#superclass : #GtLAbstractMagritteFunctionToolExamples,
	#category : #'Gt4LlmCore-Examples-Tools'
}

{ #category : #examples }
GtLToolForExampleMethodRunExamples >> exampleRunError [
	<gtExample>
	| call targetObject |
	call := self
		executeTool: GtLToolForExampleMethodRun new
		withArguments: {
			'exampleReference' -> {
				'exampleClassName' -> 'GtLExampleRunDummyExamples'.
				'methodName' -> 'errorExample'.
				'classSide' -> false
			} asDictionary
		} asDictionary.
	targetObject := call result targetObject.
	self assert: (targetObject isKindOf: GtLExampleWithResult).
	self assert: targetObject isErrorResult.
	^ call
]

{ #category : #examples }
GtLToolForExampleMethodRunExamples >> exampleRunFailure [
	<gtExample>
	| call targetObject |
	call := self
		executeTool: GtLToolForExampleMethodRun new
		withArguments: {
			'exampleReference' -> {
				'exampleClassName' -> 'GtLExampleRunDummyExamples'.
				'methodName' -> 'failingExample'.
				'classSide' -> false
			} asDictionary
		} asDictionary.
	targetObject := call result targetObject.
	self assert: (targetObject isKindOf: GtLExampleWithResult).
	self assert: targetObject isFailureResult.
	^ call
]

{ #category : #examples }
GtLToolForExampleMethodRunExamples >> exampleRunForMissingExampleClassName [
	<gtExample>
	| call |
	call := self
		executeTool: GtLToolForExampleMethodRun new
		withArguments: {
			'exampleReference' -> {
				'methodName' -> 'someMethod'.
				'classSide' -> false
			} asDictionary
		} asDictionary.
	self
		assertMissingRequiredProperties: call result targetObject
		withPropertyNames: #('exampleClassName')
		path: #('exampleReference')
		errorMessage: '@[exampleReference] required properties missing [exampleClassName]'.
	^ call
]

{ #category : #examples }
GtLToolForExampleMethodRunExamples >> exampleRunForMissingExampleReference [
	<gtExample>
	| call |
	call := self
		executeTool: GtLToolForExampleMethodRun new
		withArguments: Dictionary new.
	self
		assertMissingRequiredProperties: call result targetObject
		withPropertyNames: #('exampleReference')
		path: #(nil)
		errorMessage: 'required properties missing [exampleReference]'.
	^ call
]

{ #category : #examples }
GtLToolForExampleMethodRunExamples >> exampleRunForMissingMethodName [
	<gtExample>
	| call |
	call := self
		executeTool: GtLToolForExampleMethodRun new
		withArguments: {
			'exampleReference' -> {
				'exampleClassName' -> 'GtTMoneyExamples'.
				'classSide' -> false
			} asDictionary
		} asDictionary.
	self
		assertMissingRequiredProperties: call result targetObject
		withPropertyNames: #('methodName')
		path: #('exampleReference')
		errorMessage: '@[exampleReference] required properties missing [methodName]'.
	^ call
]

{ #category : #examples }
GtLToolForExampleMethodRunExamples >> exampleRunForNilExampleClassName [
	<gtExample>
	| call |
	call := self
		executeTool: GtLToolForExampleMethodRun new
		withArguments: {
			'exampleReference' -> {
				'exampleClassName' -> nil.
				'methodName' -> 'someMethod'.
				'classSide' -> false
			} asDictionary
		} asDictionary.
	self
		assertJSONSchemaValidationError: call result targetObject
		withPath: #('exampleReference' 'exampleClassName')
		errorMessage: '@[exampleReference/exampleClassName] string expected'.
	^ call
]

{ #category : #examples }
GtLToolForExampleMethodRunExamples >> exampleRunForNilMethodName [
	<gtExample>
	| call |
	call := self
		executeTool: GtLToolForExampleMethodRun new
		withArguments: {
			'exampleReference' -> {
				'exampleClassName' -> 'GtTMoneyExamples'.
				'methodName' -> nil.
				'classSide' -> false
			} asDictionary
		} asDictionary.
	self
		assertJSONSchemaValidationError: call result targetObject
		withPath: #('exampleReference' 'methodName')
		errorMessage: '@[exampleReference/methodName] string expected'.
	^ call
]

{ #category : #examples }
GtLToolForExampleMethodRunExamples >> exampleRunForNonExampleMethod [
	<gtExample>
	| call targetObject |
	call := self
		executeTool: GtLToolForExampleMethodRun new
		withArguments: {
			'exampleReference' -> {
				'exampleClassName' -> 'GtLExampleRunDummyExamples'.
				'methodName' -> 'regularMethod'.
				'classSide' -> false
			} asDictionary
		} asDictionary.
	targetObject := call result targetObject.
	self assert: (targetObject isKindOf: GtLMethodIsNotExampleDomainObject).
	self assert: targetObject method name equals: 'GtLExampleRunDummyExamples>>#regularMethod'.
	^ call
]

{ #category : #examples }
GtLToolForExampleMethodRunExamples >> exampleRunForUnknownClass [
	<gtExample>
	| call |
	call := self
		executeTool: GtLToolForExampleMethodRun new
		withArguments: {
			'exampleReference' -> {
				'exampleClassName' -> 'NonExistentClassXYZ123'.
				'methodName' -> 'someMethod'.
				'classSide' -> false
			} asDictionary
		} asDictionary.
	self
		assertMissingObject: call result targetObject
		withObjectName: 'NonExistentClassXYZ123'
		errorMessage: 'NonExistentClassXYZ123 is not found'.
	^ call
]

{ #category : #examples }
GtLToolForExampleMethodRunExamples >> exampleRunForUnknownMethod [
	<gtExample>
	| call |
	call := self
		executeTool: GtLToolForExampleMethodRun new
		withArguments: {
			'exampleReference' -> {
				'exampleClassName' -> 'GtTMoneyExamples'.
				'methodName' -> 'nonExistentMethodXYZ123'.
				'classSide' -> false
			} asDictionary
		} asDictionary.
	self
		assertMissingObject: call result targetObject
		withObjectName: 'GtTMoneyExamples>>#nonExistentMethodXYZ123'
		errorMessage: 'GtTMoneyExamples>>#nonExistentMethodXYZ123 is not found'.
	^ call
]

{ #category : #examples }
GtLToolForExampleMethodRunExamples >> exampleRunSuccess [
	<gtExample>
	| call targetObject |
	call := self
		executeTool: GtLToolForExampleMethodRun new
		withArguments: {
			'exampleReference' -> {
				'exampleClassName' -> 'GtTMoneyExamples'.
				'methodName' -> 'fortyTwoEuros'.
				'classSide' -> false
			} asDictionary
		} asDictionary.
	targetObject := call result targetObject.
	self assert: (targetObject isKindOf: GtLExampleWithResult).
	self assert: targetObject isSuccessResult.
	self assert: targetObject objectId isNil.
	^ call
]

{ #category : #examples }
GtLToolForExampleMethodRunExamples >> exampleRunSuccessStoresObjectId [
	<gtExample>
	| objectStorage call targetObject objectId storedObject |
	objectStorage := GtLObjectStorage new.
	call := self
		executeTool: GtLToolForExampleMethodRun new
		withArguments: {
			'exampleReference' -> {
				'exampleClassName' -> 'GtLExampleRunDummyExamples'.
				'methodName' -> 'successfulExample'.
				'classSide' -> false
			} asDictionary
		} asDictionary
		inContext: (GtLToolExecutionContext new objectStorage: objectStorage).
	targetObject := call result targetObject.
	self assert: (targetObject isKindOf: GtLExampleWithResult).
	self assert: targetObject isSuccessResult.
	objectId := targetObject objectId.
	self assert: objectId isString.
	self assert: (objectStorage objectAt: objectId) equals: 42.
	storedObject := objectStorage storedObjectAt: objectId.
	self assert: storedObject reason class equals: GtLStoredObjectExampleMethodReason.
	^ call
]
