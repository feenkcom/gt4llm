"
Examples for GtLMethodsCompilationResult domain object.
"
Class {
	#name : #GtLMethodsCompilationResultExamples,
	#superclass : #GtLDomainObjectExamples,
	#category : 'Gt4LlmCore-Examples-Domain Objects'
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
		targetMethodReference: (GtLMethodReference new
			methodClassName: 'SampleClass';
			methodName: 'failedMethod';
			classSide: false;
			yourself);
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
	| domainObject compositeView dataBlock jsonData results exceptionDetails firstTarget secondTarget |
	domainObject := self methodsCompilationResultWithMixedOutcomes.
	compositeView := domainObject llmDataViewsFor: GtLDataView new.
	self assert: compositeView dataViews size equals: 1.

	dataBlock := compositeView serializeToLlmPrimiteData.
	self assertDataBlockHasOnlyJsonData: dataBlock.

	jsonData := dataBlock compositeJsonData.
	results := jsonData at: 'methodCompilationResults'.
	self assert: results size equals: 6.
	self assert: (results first at: 'status') equals: 'compiled'.
	firstTarget := results first at: 'targetMethodReference'.
	self assert: (firstTarget at: 'methodName') equals: 'addedMethod'.
	self assert: (firstTarget at: 'methodClassName') equals: 'SampleClass'.
	self assert: (firstTarget at: 'classSide') equals: false.
	self assert: (results second at: 'status') equals: 'failed'.
	secondTarget := results second at: 'targetMethodReference'.
	self assert: (secondTarget at: 'methodName') equals: 'failedMethod'.
	self assert: (secondTarget at: 'methodClassName') equals: 'SampleClass'.
	self assert: (secondTarget at: 'classSide') equals: false.
	self assert: (results third at: 'errorReason') equals: 'Syntax error while compiling'.
	exceptionDetails := results fourth at: 'errorDetails'.
	self assert: (exceptionDetails at: #errorClass) equals: 'ZeroDivide'.
	self assert: (exceptionDetails at: #errorMessage) equals: 'ZeroDivide'.
	self assert: ((exceptionDetails at: #stackTrace) includesSubstring: 'ZeroDivide').
	self assert: (results fifth at: 'errorMessage') equals: 'Missing object: UnknownClass>>missingMethod'.
	self assert: (results fifth at: 'missingObjectName') equals: 'UnknownClass>>missingMethod'.
	self assert: (results sixth at: 'errorMessage') equals: 'Missing required argument: requiredParam'.
	self assert: (results sixth at: 'missingArgument') equals: 'requiredParam'.

	^ dataBlock
]
