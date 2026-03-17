"
Examples for GtLSmalltalkCodeEvaluationExceptionResult domain object.
"
Class {
	#name : #GtLSmalltalkCodeEvaluationExceptionResultExamples,
	#superclass : #Object,
	#category : 'Gt4LlmCore-Examples-Domain Objects'
}

{ #category : #examples }
GtLSmalltalkCodeEvaluationExceptionResultExamples >> simpleExceptionResult [
	<gtExample>
	| result |
	result := GtLSmalltalkCodeEvaluationExceptionResult new
		code: '1 / 0';
		errorMessage: 'ZeroDivide';
		errorClassName: 'ZeroDivide';
		whatFailed: 'Error while evaluating smalltalk code';
		stackTrace: 'stack trace here';
		yourself.
	
	self assert: result code equals: '1 / 0'.
	self assert: result errorMessage equals: 'ZeroDivide'.
	self assert: result errorClassName equals: 'ZeroDivide'.
	self assert: result whatFailed equals: 'Error while evaluating smalltalk code'.
	self assert: result stackTrace equals: 'stack trace here'.
	self assert: result isErrorDomainObject.
	self assert: result wasMovedToMagritteDescriptions.
	
	^ result
]

{ #category : #examples }
GtLSmalltalkCodeEvaluationExceptionResultExamples >> simpleExceptionResultSerialization [
	<gtExample>
	| result jsonObject expected |
	result := self simpleExceptionResult.
	jsonObject := GtMagritteJSONDataExporter exportObject: result.
	
	expected := NeoJSONObject new
		at: 'code' put: '1 / 0';
		at: 'errorMessage' put: 'ZeroDivide';
		at: 'errorClassName' put: 'ZeroDivide';
		at: 'whatFailed' put: 'Error while evaluating smalltalk code';
		at: 'stackTrace' put: 'stack trace here';
		yourself.
	
	self assert: jsonObject equals: expected.
	
	^ jsonObject
]
