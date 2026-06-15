"
Examples for GtLSmalltalkCodeEvaluationExceptionDomainObject domain object.
"
Class {
	#name : #GtLSmalltalkCodeEvaluationExceptionDomainObjectExamples,
	#superclass : #GtLExceptionBasedDomainObjectExamples,
	#traits : 'TGtLWithLepiterPageReferenceForDomainObjectExamples + TGtLExceptionResultSerializationAssertions',
	#classTraits : 'TGtLWithLepiterPageReferenceForDomainObjectExamples classTrait + TGtLExceptionResultSerializationAssertions classTrait',
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
	self assertDataBlockHasOnlyJsonData: dataBlock.
	
	jsonData := dataBlock compositeJsonData.
	
	self assertJsonData: jsonData hasExpectedKeys: #(#code #errorDetails #errorReason #objectId #objectValue #playgroundPageReference).
	self assert: (jsonData at: #code) equals: '1 / 0'.
	self assert: (jsonData at: #errorReason) equals: 'Error while evaluating smalltalk code'.
	
	self assert: (jsonData at: #objectId) equals: 'exception-id-123'.
	
	self 
		assert: (jsonData at: #playgroundPageReference) 
		equals: (self expectedPlaygroundPageReferenceForObjectClassName: 'ZeroDivide').

	errorDetails := jsonData at: 'errorDetails'.
	self 
		assertExceptionResult: errorDetails 
		errorClass: 'ZeroDivide' 
		errorMessage: 'ZeroDivide' 
		stackTraceIncludes: #('ZeroDivide' 'SmallInteger>>/').
	
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
				objectId: 'exception-id-123';
				code: '1 / 0';
				playgroundPageReference: (self lepiterPageReferenceForException: ex);
				errorReason: 'Error while evaluating smalltalk code';
				yourself ].
	
	self assert: domainObject code equals: '1 / 0'.
	self assert: domainObject exception class equals: ZeroDivide.
	self assert: domainObject errorReason equals: 'Error while evaluating smalltalk code'.
	self assert: domainObject objectId equals: 'exception-id-123'.
	self assert: domainObject playgroundPageReference notNil.
	self assert: (domainObject exception stackString includesSubstring: 'ZeroDivide').
	
	^ domainObject
]

{ #category : #private }
GtLSmalltalkCodeEvaluationExceptionDomainObjectExamples >> lepiterPageReferenceForException: anObject [
	^ self
		lepiterPageReferenceForObject: anObject
		withSnippetCode: '[ 1 / 0 ] on: ZeroDivide do: [ :ex | GtSystemUtility freeze: ex ]'
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
		objectValue: (GtLSerializedObjectValue fromObject: frozenException);
		playgroundPageReference: (self lepiterPageReferenceForException: frozenException);
		errorReason: 'Error while evaluating smalltalk code';
		yourself.
	
	self assert: domainObject code equals: '1 / 0'.
	self assert: domainObject exception class equals: ZeroDivide.
	self assert: domainObject errorReason equals: 'Error while evaluating smalltalk code'.
	self assert: domainObject isErrorDomainObject.
	self assert: domainObject objectValue notNil.
	self assert: domainObject playgroundPageReference notNil.
	
	^ domainObject
]
