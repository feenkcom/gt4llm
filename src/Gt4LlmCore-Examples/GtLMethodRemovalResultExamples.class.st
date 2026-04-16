"
Examples for GtLMethodRemovalResult domain object.
"
Class {
	#name : #GtLMethodRemovalResultExamples,
	#superclass : #GtLMethodChangeResultExamples,
	#category : #'Gt4LlmCore-Examples-Domain Objects'
}

{ #category : #examples }
GtLMethodRemovalResultExamples >> methodRemovalResultCreation [
	<gtExample>
	| methodWithSource targetMethodReference result |
	methodWithSource := GtLMethodWithSource new
		methodReference: (GtLMethodReference new
			methodClassName: 'SampleClass';
			methodName: 'sampleMethod';
			classSide: false;
			yourself);
		sourceCode: 'sampleMethod ^ 42';
		yourself.
	targetMethodReference := GtLMethodReference new
		methodClassName: 'SampleClass';
		methodName: 'sampleMethod';
		classSide: false;
		yourself.
	result := GtLMethodRemovalResult new
		removedMethod: methodWithSource;
		status: 'removed';
		yourself.
	self assert: result status equals: 'removed'.
	self assert: result removedMethod methodName equals: 'sampleMethod'.
	self assert: result removedMethod methodClassName equals: 'SampleClass'.
	self assert: result removedMethod sourceCode equals: 'sampleMethod ^ 42'.
	self assert: result targetMethodReference equals: targetMethodReference.
	self assertResultIsMethod: result.
	self assertResultIsMethodRemoval: result.
	^ result
]

{ #category : #examples }
GtLMethodRemovalResultExamples >> methodRemovalResultDataViewSerialization [
	<gtExample>
	<return: #GtLPrimitiveMessageDataBlock>
	| domainObject compositeView dataBlock expected |
	domainObject := self methodRemovalResultCreation.
	compositeView := domainObject llmDataViewsFor: GtLDataView new.
	self assert: compositeView dataViews size equals: 1.
	
	dataBlock := compositeView serializeToLlmPrimiteData.
	self assertDataBlockHasOnlyJsonData: dataBlock.
	
	expected := Dictionary new
		at: #status put: 'removed';
		yourself.
	self assertDataBlock: dataBlock hasLlmJsonData: expected.
	
	^ dataBlock
]
