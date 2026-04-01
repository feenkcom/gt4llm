"
Examples for GtLMethodsCompilationResult domain object.
"
Class {
	#name : #GtLMethodsCompilationResultExamples,
	#superclass : #GtLMagritteDomainObjectExamples,
	#category : 'Gt4LlmCore-Examples-Domain Objects'
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

{ #category : #'examples - data view' }
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
		at: #status put: 'compiled';
		yourself.
	methodTwoJson := NeoJSONObject new
		at: #status put: 'compiled';
		yourself.
	expected := Dictionary new
		at: #methods put: (NeoJSONArray with: methodOneJson with: methodTwoJson);
		yourself.
	self assert: jsonData equals: expected.
	
	^ dataBlock
]
