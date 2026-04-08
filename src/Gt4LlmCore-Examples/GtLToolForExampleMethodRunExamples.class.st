"
Examples for GtLMagritteToolForExampleMethodRun.
"
Class {
	#name : #GtLToolForExampleMethodRunExamples,
	#superclass : #GtLAbstractMagritteFunctionToolExamples,
	#category : 'Gt4LlmCore-Examples-Tools'
}

{ #category : #examples }
GtLToolForExampleMethodRunExamples >> exampleRunError [
	<gtExample>
	| targetObject |
	
	targetObject := self
		executeTool: GtLToolForExampleMethodRun new
		withArguments: {
			'exampleReference' -> {
				'exampleClassName' -> 'GtLExampleRunDummyExamples'.
				'methodName' -> 'errorExample'.
				'classSide' -> false
			} asDictionary
		} asDictionary.
	
	self assert: (targetObject isKindOf: GtLExampleWithResult).
	self assert: targetObject isErrorResult.
	
	^ targetObject
]

{ #category : #examples }
GtLToolForExampleMethodRunExamples >> exampleRunFailure [
	<gtExample>
	| targetObject |
	
	targetObject := self
		executeTool: GtLToolForExampleMethodRun new
		withArguments: {
			'exampleReference' -> {
				'exampleClassName' -> 'GtLExampleRunDummyExamples'.
				'methodName' -> 'failingExample'.
				'classSide' -> false
			} asDictionary
		} asDictionary.
	
	self assert: (targetObject isKindOf: GtLExampleWithResult).
	self assert: targetObject isFailureResult.
	
	^ targetObject
]

{ #category : #examples }
GtLToolForExampleMethodRunExamples >> exampleRunForMissingExampleClassName [
	<gtExample>
	| targetObject |
	
	targetObject := self
		executeTool: GtLToolForExampleMethodRun new
		withArguments: {
			'exampleReference' -> {
				'methodName' -> 'someMethod'.
				'classSide' -> false
			} asDictionary
		} asDictionary.
	
	self
		assertMissingRequiredProperties: targetObject
		withPropertyNames: #('exampleClassName')
		path: #('exampleReference')
		errorMessage: '@[exampleReference] required properties missing [exampleClassName]'.
	
	^ targetObject
]

{ #category : #examples }
GtLToolForExampleMethodRunExamples >> exampleRunForMissingExampleReference [
	<gtExample>
	| targetObject |
	
	targetObject := self
		executeTool: GtLToolForExampleMethodRun new
		withArguments: Dictionary new.
	
	self
		assertMissingRequiredProperties: targetObject
		withPropertyNames: #('exampleReference')
		path: #(nil)
		errorMessage: 'required properties missing [exampleReference]'.
	
	^ targetObject
]

{ #category : #examples }
GtLToolForExampleMethodRunExamples >> exampleRunForMissingMethodName [
	<gtExample>
	| targetObject |
	
	targetObject := self
		executeTool: GtLToolForExampleMethodRun new
		withArguments: {
			'exampleReference' -> {
				'exampleClassName' -> 'GtTMoneyExamples'.
				'classSide' -> false
			} asDictionary
		} asDictionary.
	
	self
		assertMissingRequiredProperties: targetObject
		withPropertyNames: #('methodName')
		path: #('exampleReference')
		errorMessage: '@[exampleReference] required properties missing [methodName]'.
	
	^ targetObject
]

{ #category : #examples }
GtLToolForExampleMethodRunExamples >> exampleRunForNilExampleClassName [
	<gtExample>
	| targetObject |
	
	targetObject := self
		executeTool: GtLToolForExampleMethodRun new
		withArguments: {
			'exampleReference' -> {
				'exampleClassName' -> nil.
				'methodName' -> 'someMethod'.
				'classSide' -> false
			} asDictionary
		} asDictionary.
	
	self
		assertJSONSchemaValidationError: targetObject
		withPath: #('exampleReference' 'exampleClassName')
		errorMessage: '@[exampleReference/exampleClassName] string expected'.
	
	^ targetObject
]

{ #category : #examples }
GtLToolForExampleMethodRunExamples >> exampleRunForNilMethodName [
	<gtExample>
	| targetObject |
	
	targetObject := self
		executeTool: GtLToolForExampleMethodRun new
		withArguments: {
			'exampleReference' -> {
				'exampleClassName' -> 'GtTMoneyExamples'.
				'methodName' -> nil.
				'classSide' -> false
			} asDictionary
		} asDictionary.
	
	self
		assertJSONSchemaValidationError: targetObject
		withPath: #('exampleReference' 'methodName')
		errorMessage: '@[exampleReference/methodName] string expected'.
	
	^ targetObject
]

{ #category : #examples }
GtLToolForExampleMethodRunExamples >> exampleRunForNonExampleMethod [
	<gtExample>
	| targetObject |
	
	targetObject := self
		executeTool: GtLToolForExampleMethodRun new
		withArguments: {
			'exampleReference' -> {
				'exampleClassName' -> 'GtLExampleRunDummyExamples'.
				'methodName' -> 'regularMethod'.
				'classSide' -> false
			} asDictionary
		} asDictionary.
	
	self assert: (targetObject isKindOf: GtLMethodIsNotExampleDomainObject).
	self assert: targetObject method name equals: 'GtLExampleRunDummyExamples>>#regularMethod'.
	
	^ targetObject
]

{ #category : #examples }
GtLToolForExampleMethodRunExamples >> exampleRunForUnknownClass [
	<gtExample>
	| targetObject |
	
	targetObject := self
		executeTool: GtLToolForExampleMethodRun new
		withArguments: {
			'exampleReference' -> {
				'exampleClassName' -> 'NonExistentClassXYZ123'.
				'methodName' -> 'someMethod'.
				'classSide' -> false
			} asDictionary
		} asDictionary.
	
	self
		assertMissingObject: targetObject
		withObjectName: 'NonExistentClassXYZ123'
		errorMessage: 'NonExistentClassXYZ123 is not found'.
	
	^ targetObject
]

{ #category : #examples }
GtLToolForExampleMethodRunExamples >> exampleRunForUnknownMethod [
	<gtExample>
	| targetObject |
	
	targetObject := self
		executeTool: GtLToolForExampleMethodRun new
		withArguments: {
			'exampleReference' -> {
				'exampleClassName' -> 'GtTMoneyExamples'.
				'methodName' -> 'nonExistentMethodXYZ123'.
				'classSide' -> false
			} asDictionary
		} asDictionary.
	
	self
		assertMissingObject: targetObject
		withObjectName: 'GtTMoneyExamples>>#nonExistentMethodXYZ123'
		errorMessage: 'GtTMoneyExamples>>#nonExistentMethodXYZ123 is not found'.
	
	^ targetObject
]

{ #category : #examples }
GtLToolForExampleMethodRunExamples >> exampleRunSuccess [
	<gtExample>
	| targetObject |
	
	targetObject := self
		executeTool: GtLToolForExampleMethodRun new
		withArguments: {
			'exampleReference' -> {
				'exampleClassName' -> 'GtTMoneyExamples'.
				'methodName' -> 'fortyTwoEuros'.
				'classSide' -> false
			} asDictionary
		} asDictionary.
	
	self assert: (targetObject isKindOf: GtLExampleWithResult).
	self assert: targetObject isSuccessResult.
	self assert: targetObject objectId isNil.
	
	^ targetObject
]

{ #category : #examples }
GtLToolForExampleMethodRunExamples >> exampleRunSuccessStoresObjectId [
	<gtExample>
	| objectStorage targetObject objectId storedObject |
	objectStorage := GtLObjectStorage new.
	
	targetObject := self
		executeTool: GtLToolForExampleMethodRun new
		withArguments: {
			'exampleReference' -> {
				'exampleClassName' -> 'GtLExampleRunDummyExamples'.
				'methodName' -> 'successfulExample'.
				'classSide' -> false
			} asDictionary
		} asDictionary
		inContext: (GtLToolExecutionContext new objectStorage: objectStorage).
	
	self assert: (targetObject isKindOf: GtLExampleWithResult).
	self assert: targetObject isSuccessResult.
	objectId := targetObject objectId.
	self assert: objectId isString.
	self assert: (objectStorage objectAt: objectId) equals: 42.
	storedObject := objectStorage storedObjectAt: objectId.
	self assert: storedObject reason class equals: GtLStoredObjectExampleMethodReason.
	
	^ targetObject
]
