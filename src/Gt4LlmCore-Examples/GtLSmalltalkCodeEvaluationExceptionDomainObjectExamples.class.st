"
Examples for GtLSmalltalkCodeEvaluationExceptionDomainObject domain object.
"
Class {
	#name : #GtLSmalltalkCodeEvaluationExceptionDomainObjectExamples,
	#superclass : #GtLErroneousConditionDomainObjectExamples,
	#category : #'Gt4LlmCore-Examples-Domain Objects'
}

{ #category : #examples }
GtLSmalltalkCodeEvaluationExceptionDomainObjectExamples >> exceptionDomainObjectDataViewSerialization [
	<gtExample>
	<return: #Dictionary>
	| domainObject compositeView dataBlock jsonData errorDetails |
	domainObject := self exceptionDomainObjectUsingFreezeClassMethod.
	
	compositeView := domainObject llmDataViewsFor: GtLDataView new.
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
GtLSmalltalkCodeEvaluationExceptionDomainObjectExamples >> exceptionDomainObjectUsingFreezeClassMethod [
	<gtExample>
	<return: #GtLSmalltalkCodeEvaluationExceptionDomainObject>
	| domainObject |
	domainObject := [ 1 / 0 ]
		on: ZeroDivide
		do: [ :ex | 
			(GtLSmalltalkCodeEvaluationExceptionDomainObject freeze: ex)
				code: '1 / 0';
				errorReason: 'Error while evaluating smalltalk code';
				yourself ].
	
	self assert: domainObject code equals: '1 / 0'.
	self assert: domainObject exception class equals: ZeroDivide.
	self assert: domainObject errorReason equals: 'Error while evaluating smalltalk code'.
	self assert: (domainObject stackTrace includesSubstring: 'ZeroDivide').
	
	^ domainObject
]

{ #category : #examples }
GtLSmalltalkCodeEvaluationExceptionDomainObjectExamples >> simpleExceptionDomainObject [
	<gtExample>
	<return: #GtLSmalltalkCodeEvaluationExceptionDomainObject>
	| domainObject frozenException |
	frozenException := [ 1 / 0 ]
		on: ZeroDivide
		do: [ :ex | GtSystemUtility freeze: ex ].
	
	domainObject := GtLSmalltalkCodeEvaluationExceptionDomainObject new
		code: '1 / 0';
		exception: frozenException;
		errorReason: 'Error while evaluating smalltalk code';
		yourself.
	
	self assert: domainObject code equals: '1 / 0'.
	self assert: domainObject exception class equals: ZeroDivide.
	self assert: domainObject errorReason equals: 'Error while evaluating smalltalk code'.
	self assert: domainObject isErrorDomainObject.
	
	^ domainObject
]
