Class {
	#name : #GtLMethodCompilationExceptionDomainObjectExamples,
	#superclass : #GtLErroneousConditionDomainObjectExamples,
	#traits : 'TGtLExceptionDomainObjectAssertions',
	#classTraits : 'TGtLExceptionDomainObjectAssertions classTrait',
	#category : 'Gt4LlmCore-Examples-Domain Objects'
}

{ #category : #examples }
GtLMethodCompilationExceptionDomainObjectExamples >> basicMethodCompilationException [
	<gtExample>
	<return: #GtLMethodCompilationExceptionDomainObject>
	| domainObject error |
	
	error := [ 1 / 0 ] on: Error do: [ :e | e freeze ].
	domainObject := GtLMethodCompilationExceptionDomainObject new
		freeze: error;
		targetClass: Object;
		protocolName: 'testing';
		sourceCode: 'badMethod ^';
		description: 'Syntax error while compiling'.
	
	self assert: domainObject targetClassName equals: 'Object'.
	self assert: domainObject protocolName equals: 'testing'.
	self assert: domainObject sourceCode equals: 'badMethod ^'.
	self assert: domainObject description equals: 'Syntax error while compiling'.
	self 
		assertExceptionDomainObject: domainObject 
		withExceptionClass: ZeroDivide 
		messageSubstring: 'ZeroDivide'.
	
	^ domainObject
]

{ #category : #examples }
GtLMethodCompilationExceptionDomainObjectExamples >> methodCompilationExceptionDataViewSerialization [
	<gtExample>
	<return: #GtLPrimitiveMessageDataBlock>
	| domainObject compositeView dataBlock jsonData errorDetails |
	domainObject := self basicMethodCompilationException.
	
	compositeView := domainObject llmDataViewsFor: GtLDataView new.
	self assert: compositeView dataViews size equals: 2.
	
	dataBlock := compositeView serializeToLlmPrimiteData.
	self assertDataBlockHasOnlyJsonData: dataBlock.
	
	jsonData := dataBlock compositeJsonData.
	self assert: (jsonData at: 'methodClass') equals: 'Object'.
	self assert: (jsonData at: 'methodProtocol') equals: 'testing'.
	self assert: (jsonData at: 'sourceCode') equals: 'badMethod ^'.
	self assert: (jsonData at: 'errorReason') equals: 'Syntax error while compiling'.
	
	errorDetails := jsonData at: 'errorDetails'.
	self assert: (errorDetails at: #errorClass) equals: 'ZeroDivide'.
	self assert: (errorDetails at: #errorMessage) equals: 'ZeroDivide'.
	self assert: (errorDetails at: #stackTrace) isNotEmpty.
	
	^ dataBlock
]
