"
Examples for GtLSmalltalkCodeEvaluationExceptionResult domain object.
"
Class {
	#name : #GtLSmalltalkCodeEvaluationExceptionResultExamples,
	#superclass : #Object,
	#category : 'Gt4LlmCore-Examples-Domain Objects'
}

{ #category : #examples }
GtLSmalltalkCodeEvaluationExceptionResultExamples >> exceptionResultWithFrozenException [
	<gtExample>
	<return: #GtLSmalltalkCodeEvaluationExceptionResult>
	| result |
	result := [ 1 / 0 ] on: ZeroDivide do: [ :ex |
		| frozenEx |
		frozenEx := GtSystemUtility freeze: ex.
		GtLSmalltalkCodeEvaluationExceptionResult new
			code: '1 / 0';
			exception: frozenEx;
			errorMessage: frozenEx messageText;
			errorClassName: frozenEx class name;
			whatFailed: 'Error while evaluating smalltalk code';
			stackTrace: (String lf join: ((frozenEx signalerContext stackOfSize: 10) collect: #gtDisplayString));
			yourself ].
	
	self assert: result code equals: '1 / 0'.
	self assert: result exception class equals: ZeroDivide.
	self assert: result errorClassName equals: 'ZeroDivide'.
	self assert: result whatFailed equals: 'Error while evaluating smalltalk code'.
	self assert: (result stackTrace includesSubstring: 'ZeroDivide').
	
	^ result
]

{ #category : #examples }
GtLSmalltalkCodeEvaluationExceptionResultExamples >> exceptionResultWithFrozenExceptionDataViewSerialization [
	<gtExample>
	<return: #Dictionary>
	| result compositeView dataBlock jsonData errorDetails |
	result := self exceptionResultWithFrozenException.
	
	compositeView := result llmDataViewsFor: GtLDataView new.
	self assert: compositeView dataViews size equals: 2.
	
	dataBlock := compositeView serializeToLlmPrimiteData.
	self assert: dataBlock dataBlocks size equals: 1.
	self assert: dataBlock imageDataBlocks isEmpty.
	
	jsonData := dataBlock compositeJsonData.
	self assert: jsonData keys sorted equals: #('code' 'errorDetails' 'errorReason').
	self assert: (jsonData at: 'code') equals: '1 / 0'.
	self assert: (jsonData at: 'errorReason') equals: 'Error while evaluating smalltalk code'.
	
	errorDetails := jsonData at: 'errorDetails'.
	self assert: (errorDetails at: #errorMessage) equals: 'ZeroDivide'.
	self assert: (errorDetails at: #errorClass) equals: 'ZeroDivide'.
	self assert: ((errorDetails at: #stackTrace) includesSubstring: 'ZeroDivide').
	self assert: ((errorDetails at: #stackTrace) includesSubstring: 'SmallInteger>>/') .
	
	^ jsonData
]

{ #category : #examples }
GtLSmalltalkCodeEvaluationExceptionResultExamples >> simpleExceptionResult [
	<gtExample>
	<return: #GtLSmalltalkCodeEvaluationExceptionResult>
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
GtLSmalltalkCodeEvaluationExceptionResultExamples >> simpleExceptionResultDataViewSerialization [
	<gtExample>
	<return: #Dictionary>
	| result compositeView dataBlock jsonData expectedJson |
	result := self simpleExceptionResult.
	
	compositeView := result llmDataViewsFor: GtLDataView new.
	self assert: compositeView dataViews size equals: 2.
	
	dataBlock := compositeView serializeToLlmPrimiteData.
	self assert: dataBlock dataBlocks size equals: 1.
	self assert: dataBlock imageDataBlocks isEmpty.
	
	jsonData := dataBlock compositeJsonData.
	"Without exception set, only code and errorReason are present"
	expectedJson := {
		'code' -> '1 / 0'.
		'errorReason' -> 'Error while evaluating smalltalk code'
	} asDictionary.
	self assert: jsonData equals: expectedJson.
	
	^ jsonData
]
