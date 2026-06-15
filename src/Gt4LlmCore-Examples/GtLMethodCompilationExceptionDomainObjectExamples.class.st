Class {
	#name : #GtLMethodCompilationExceptionDomainObjectExamples,
	#superclass : #GtLExceptionBasedDomainObjectExamples,
	#traits : 'TGtLExceptionDomainObjectAssertions + TGtLExceptionResultSerializationAssertions',
	#classTraits : 'TGtLExceptionDomainObjectAssertions classTrait + TGtLExceptionResultSerializationAssertions classTrait',
	#category : #'Gt4LlmCore-Examples-Domain Objects'
}

{ #category : #examples }
GtLMethodCompilationExceptionDomainObjectExamples >> basicMethodCompilationException [
	<gtExample>
	<return: #GtLMethodCompilationExceptionDomainObject>
	| domainObject |
	
	domainObject := [ 1 / 0 ]
		on: Error
		do: [ :ex | 
			(GtLMethodCompilationExceptionDomainObject freeze: ex)
				objectId: 'exception-id-123';
				targetClass: Object;
				protocolName: 'testing';
				sourceCode: 'badMethod ^';
				description: 'Syntax error while compiling';
				yourself ].
	
	self assert: domainObject targetClassName equals: 'Object'.
	self assert: domainObject protocolName equals: 'testing'.
	self assert: domainObject sourceCode equals: 'badMethod ^'.
	self assert: domainObject description equals: 'Syntax error while compiling'.
	self assert: domainObject objectValue notNil.
	self assert: domainObject objectId equals: 'exception-id-123'.
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
	self assertJsonData: jsonData hasExpectedKeys: #(#errorDetails #errorReason #objectId #objectValue #playgroundPageReference #protocolName #sourceCode #targetClassName).
	self assert: (jsonData at: #targetClassName) equals: #Object.
	self assert: (jsonData at: #protocolName) equals: 'testing'.
	self assert: (jsonData at: #sourceCode) equals: 'badMethod ^'.
	self assert: (jsonData at: #errorReason) equals: 'Syntax error while compiling'.
	self assert: (jsonData at: #objectId) equals: 'exception-id-123'.
	self assert: (jsonData at: #objectValue) isDictionary.
	self assert: (jsonData at: #playgroundPageReference) isNil.
	
	errorDetails := jsonData at: 'errorDetails'.
	self assertExceptionResult: errorDetails errorClass: 'ZeroDivide' errorMessage: 'ZeroDivide' stackTraceIncludes: #('ZeroDivide' 'SmallInteger>>/').
	
	^ dataBlock
]
