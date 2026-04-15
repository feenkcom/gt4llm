"
Examples for GtLMethodsCompilationResult domain object.
"
Class {
	#name : #GtLMethodsCompilationResultExamples,
	#superclass : #GtLDomainObjectExamples,
	#traits : 'TGtLExceptionResultAssertions',
	#classTraits : 'TGtLExceptionResultAssertions classTrait',
	#category : #'Gt4LlmCore-Examples-Domain Objects'
}

{ #category : #examples }
GtLMethodsCompilationResultExamples >> methodsCompilationResultCreation [
	<gtExample>
	| resultOne resultTwo result |
	resultOne := GtLMethodCompilationResultExamples new methodCompilationResultMethodAddition.
	resultTwo := GtLMethodCompilationResultExamples new methodCompilationResultCreation.
	result := GtLMethodsCompilationResult new
		methods: { resultOne. resultTwo };
		yourself.
	self assert: result methods size equals: 2.
	self assert: result methods first status equals: 'compiled'.
	self assert: result methods first oldMethod isNil.
	self assert: result methods first targetMethodReference methodName equals: 'addedMethod'.
	self assert: result methods second status equals: 'compiled'.
	self assert: result methods second targetMethodReference methodName equals: 'sampleMethod'.
	^ result
]

{ #category : #examples }
GtLMethodsCompilationResultExamples >> methodsCompilationResultDataViewSerialization [
	<gtExample>
	<return: #GtLPrimitiveMessageDataBlock>
	| domainObject compositeView dataBlock jsonData expected methodOneJson methodTwoJson methodOneTargetJson methodTwoTargetJson |
	domainObject := self methodsCompilationResultCreation.
	compositeView := domainObject llmDataViewsFor: GtLDataView new.
	self assert: compositeView dataViews size equals: 1.

	dataBlock := compositeView serializeToLlmPrimiteData.
	self assertDataBlockHasOnlyJsonData: dataBlock.

	jsonData := dataBlock compositeJsonData.
	methodOneTargetJson := NeoJSONObject new
		at: 'methodName' put: 'addedMethod';
		at: 'classSide' put: false;
		at: 'methodClassName' put: 'SampleClass';
		yourself.
	methodOneJson := NeoJSONObject new
		at: 'status' put: 'compiled';
		at: 'targetMethodReference' put: methodOneTargetJson;
		yourself.
	methodTwoTargetJson := NeoJSONObject new
		at: 'methodName' put: 'sampleMethod';
		at: 'classSide' put: false;
		at: 'methodClassName' put: 'SampleClass';
		yourself.
	methodTwoJson := NeoJSONObject new
		at: 'status' put: 'compiled';
		at: 'targetMethodReference' put: methodTwoTargetJson;
		yourself.
	expected := Dictionary new
		at: 'methodCompilationResults'
			put: (Array with: methodOneJson with: methodTwoJson);
		yourself.
	self assert: jsonData equals: expected.

	^ dataBlock
]

{ #category : #examples }
GtLMethodsCompilationResultExamples >> methodsCompilationResultWithMixedOutcomes [
	<gtExample>
	| compiledResult failedResult exceptionResult missingMethodResult missingArgumentResult result |
	compiledResult := GtLMethodCompilationResultExamples new methodCompilationResultMethodAddition.
	failedResult := GtLMethodCompilationResult new
		oldMethod: (GtLMethodWithSource new
			methodReference: (GtLMethodReference new
				methodClassName: 'SampleClass';
				methodName: 'failedMethod';
				classSide: false;
				yourself);
			sourceCode: 'failedMethod ^ 1';
			yourself);
		newMethod: (GtLMethodWithSource new
			methodReference: (GtLMethodReference new
				methodClassName: 'SampleClass';
				methodName: 'failedMethod';
				classSide: false;
				yourself);
			sourceCode: 'failedMethod ^';
			yourself);
		status: 'failed';
		yourself.
	exceptionResult := GtLMethodCompilationExceptionDomainObjectExamples new basicMethodCompilationException.
	missingMethodResult := GtLMissingDomainObject new
		missingObjectName: 'UnknownClass>>missingMethod';
		errorMessage: 'Missing object: UnknownClass>>missingMethod';
		yourself.
	missingArgumentResult := GtLMissingArgumentDomainObjectExamples new basicMissingArgumentDomainObject.
	result := GtLMethodsCompilationResult new
		methodCompilationResults: { compiledResult. failedResult. exceptionResult. missingMethodResult. missingArgumentResult };
		yourself.
	self assert: result methodCompilationResults size equals: 5.
	self assert: result methodCompilationResults first class equals: GtLMethodCompilationResult.
	self assert: result methodCompilationResults first status equals: 'compiled'.
	self assert: result methodCompilationResults first targetMethodReference methodName equals: 'addedMethod'.
	self assert: result methodCompilationResults second class equals: GtLMethodCompilationResult.
	self assert: result methodCompilationResults second status equals: 'failed'.
	self assert: result methodCompilationResults second oldMethod sourceCode equals: 'failedMethod ^ 1'.
	self assert: result methodCompilationResults second newMethod sourceCode equals: 'failedMethod ^'.
	self assert: result methodCompilationResults second targetMethodReference methodName equals: 'failedMethod'.
	self assert: result methodCompilationResults third class equals: GtLMethodCompilationExceptionDomainObject.
	self assert: result methodCompilationResults fourth class equals: GtLMissingDomainObject.
	self assert: result methodCompilationResults fifth class equals: GtLMissingArgumentDomainObject.
	^ result
]

{ #category : #examples }
GtLMethodsCompilationResultExamples >> methodsCompilationResultWithMixedOutcomesDataViewSerialization [
	<gtExample>
	<return: #GtLPrimitiveMessageDataBlock>
	| domainObject compositeView dataBlock jsonData results firstResult secondResult thirdResult fifthResult sixthResult |
	domainObject := self methodsCompilationResultWithMixedOutcomes.
	compositeView := domainObject llmDataViewsFor: GtLDataView new.
	self assert: compositeView dataViews size equals: 1.

	dataBlock := compositeView serializeToLlmPrimiteData.
	self assertDataBlockHasOnlyJsonData: dataBlock.

	jsonData := dataBlock compositeJsonData.
	results := jsonData at: 'methodCompilationResults'.
	self assert: results size equals: 6.

	firstResult := NeoJSONObject new
		at: 'status' put: 'compiled';
		at: 'targetMethodReference' put: (NeoJSONObject new
			at: 'classSide' put: false;
			at: 'methodClassName' put: 'SampleClass';
			at: 'methodName' put: 'addedMethod';
			yourself);
		yourself.
	self assert: results first equals: firstResult.

	secondResult := NeoJSONObject new
		at: 'status' put: 'failed';
		at: 'targetMethodReference' put: (NeoJSONObject new
			at: 'classSide' put: false;
			at: 'methodClassName' put: 'SampleClass';
			at: 'methodName' put: 'failedMethod';
			yourself);
		yourself.
	self assert: results second equals: secondResult.

	thirdResult := NeoJSONObject new
		at: 'errorReason' put: 'Syntax error while compiling';
		at: 'methodClass' put: 'Object';
		at: 'methodProtocol' put: 'testing';
		at: 'sourceCode' put: 'badMethod ^';
		yourself.
	self assert: results third equals: thirdResult.

	self
		assertExceptionResult: (results fourth at: 'errorDetails')
		errorClass: 'ZeroDivide'
		errorMessage: 'ZeroDivide'
		stackTraceIncludes: #('ZeroDivide').

	fifthResult := NeoJSONObject new
		at: 'errorMessage' put: 'Missing object: UnknownClass>>missingMethod';
		at: 'missingObjectName' put: 'UnknownClass>>missingMethod';
		yourself.
	self assert: results fifth equals: fifthResult.

	sixthResult := NeoJSONObject new
		at: 'errorMessage' put: 'Missing required argument: requiredParam';
		at: 'missingArgument' put: 'requiredParam';
		yourself.
	self assert: results sixth equals: sixthResult.

	^ dataBlock
]
