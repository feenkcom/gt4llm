"
Examples for GtLMethodsRemovalResult domain object.
"
Class {
	#name : #GtLMethodsRemovalResultExamples,
	#superclass : #GtLMagritteDomainObjectExamples,
	#category : #'Gt4LlmCore-Examples-Domain Objects'
}

{ #category : #examples }
GtLMethodsRemovalResultExamples >> methodsRemovalResultCreation [
	<gtExample>
	| methodOne methodTwo result |
	methodOne := GtLMethodRemovalResult new
		removedMethod: (GtLMethodWithSource new
			methodReference: (GtLMethodReference new
				methodClassName: 'SampleClass';
				methodName: 'method1';
				classSide: false;
				yourself);
			sourceCode: 'method1 ^ 1';
			yourself);
		status: 'removed';
		yourself.
	methodTwo := GtLMethodRemovalResult new
		removedMethod: (GtLMethodWithSource new
			methodReference: (GtLMethodReference new
				methodClassName: 'SampleClass';
				methodName: 'method2';
				classSide: true;
				yourself);
			sourceCode: 'method2 ^ 2';
			yourself);
		status: 'removed';
		yourself.
	result := GtLMethodsRemovalResult new
		methods: { methodOne. methodTwo };
		yourself.
	self assert: result methods size equals: 2.
	self assert: result methods first status equals: 'removed'.
	self assert: result methods second status equals: 'removed'.
	^ result
]

{ #category : #'examples - data view' }
GtLMethodsRemovalResultExamples >> methodsRemovalResultDataViewSerialization [
	<gtExample>
	<return: #GtLPrimitiveMessageDataBlock>
	| domainObject compositeView dataBlock jsonData expected |
	domainObject := self methodsRemovalResultCreation.
	compositeView := domainObject llmDataViewsFor: GtLDataView new.
	self assert: compositeView dataViews size equals: 1.
	
	dataBlock := compositeView serializeToLlmPrimiteData.
	self assert: dataBlock isNotNil.
	self assert: dataBlock dataBlocks size equals: 1.
	self assert: dataBlock imageDataBlocks isEmpty.
	
	jsonData := dataBlock compositeJsonData.
	expected := Dictionary new
		at: #methods put: (NeoJSONArray withAll: {
			NeoJSONObject new at: #status put: 'removed'; yourself.
			NeoJSONObject new at: #status put: 'removed'; yourself });
		yourself.
	self assert: jsonData equals: expected.
	
	^ dataBlock
]
