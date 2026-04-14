"
Examples for GtLMethodsCompilationResult domain object.
"
Class {
	#name : #GtLMethodsCompilationResultExamples,
	#superclass : #GtLMagritteDomainObjectExamples,
	#category : #'Gt4LlmCore-Examples-Domain Objects'
}

{ #category : #examples }
GtLMethodsCompilationResultExamples >> methodsCompilationResultCreation [
	<gtExample>
	| resultOne resultTwo result |
	resultOne := GtLMethodCompilationResult new
		oldMethod: nil;
		newMethod: (GtLMethodWithSource new
			methodReference: (GtLMethodReference new
				methodClassName: 'SampleClass';
				methodName: 'methodOne';
				classSide: false;
				yourself);
			sourceCode: 'methodOne ^ 1';
			yourself);
		status: 'compiled';
		yourself.
	resultTwo := GtLMethodCompilationResult new
		oldMethod: (GtLMethodWithSource new
			methodReference: (GtLMethodReference new
				methodClassName: 'SampleClass';
				methodName: 'methodTwo';
				classSide: false;
				yourself);
			sourceCode: 'methodTwo ^ 2';
			yourself);
		newMethod: (GtLMethodWithSource new
			methodReference: (GtLMethodReference new
				methodClassName: 'SampleClass';
				methodName: 'methodTwo';
				classSide: false;
				yourself);
			sourceCode: 'methodTwo ^ 22';
			yourself);
		status: 'compiled';
		yourself.
	result := GtLMethodsCompilationResult new
		methods: { resultOne. resultTwo };
		yourself.
	self assert: result methods size equals: 2.
	self assert: result methods first status equals: 'compiled'.
	self assert: result methods second status equals: 'compiled'.
	^ result
]

{ #category : #examples }
GtLMethodsCompilationResultExamples >> methodsCompilationResultDataViewSerialization [
	<gtExample>
	<return: #GtLPrimitiveMessageDataBlock>
	| domainObject compositeView dataBlock jsonData expected methodOneJson methodTwoJson |
	domainObject := self methodsCompilationResultCreation.
	compositeView := domainObject llmDataViewsFor: GtLDataView new.
	self assert: compositeView dataViews size equals: 1.

	dataBlock := compositeView serializeToLlmPrimiteData.
	self assert: dataBlock isNotNil.
	self assert: dataBlock dataBlocks size equals: 1.
	self assert: dataBlock imageDataBlocks isEmpty.

	jsonData := dataBlock compositeJsonData.
	methodOneJson := NeoJSONObject new
		at: 'status' put: 'compiled';
		yourself.
	methodTwoJson := NeoJSONObject new
		at: 'status' put: 'compiled';
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
	compiledResult := GtLMethodCompilationResult new
		oldMethod: nil;
		newMethod: (GtLMethodWithSource new
			methodReference: (GtLMethodReference new
				methodClassName: 'SampleClass';
				methodName: 'compiledMethod';
				classSide: false;
				yourself);
			sourceCode: 'compiledMethod ^ 1';
			yourself);
		status: 'compiled';
		yourself.
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
	self assert: result methodCompilationResults second class equals: GtLMethodCompilationResult.
	self assert: result methodCompilationResults second status equals: 'failed'.
	self assert: result methodCompilationResults second oldMethod sourceCode equals: 'failedMethod ^ 1'.
	self assert: result methodCompilationResults second newMethod sourceCode equals: 'failedMethod ^'.
	self assert: result methodCompilationResults third class equals: GtLMethodCompilationExceptionDomainObject.
	self assert: result methodCompilationResults fourth class equals: GtLMissingDomainObject.
	self assert: result methodCompilationResults fifth class equals: GtLMissingArgumentDomainObject.
	^ result
]

{ #category : #examples }
GtLMethodsCompilationResultExamples >> methodsCompilationResultWithMixedOutcomesDataViewSerialization [
	<gtExample>
	<return: #GtLPrimitiveMessageDataBlock>
	| domainObject compositeView dataBlock jsonData results exceptionDetails |
	domainObject := self methodsCompilationResultWithMixedOutcomes.
	compositeView := domainObject llmDataViewsFor: GtLDataView new.
	self assert: compositeView dataViews size equals: 1.

	dataBlock := compositeView serializeToLlmPrimiteData.
	self assert: dataBlock isNotNil.
	self assert: dataBlock dataBlocks size equals: 1.
	self assert: dataBlock imageDataBlocks isEmpty.

	jsonData := dataBlock compositeJsonData.
	results := jsonData at: 'methodCompilationResults'.
	self assert: results size equals: 6.
	self assert: (results first at: 'status') equals: 'compiled'.
	self assert: (results second at: 'status') equals: 'failed'.
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
