"
Examples for GtLMethodCompilationResult domain object.
"
Class {
	#name : #GtLMethodCompilationResultExamples,
	#superclass : #GtLMethodChangeResultExamples,
	#category : #'Gt4LlmCore-Examples-Domain Objects'
}

{ #category : #examples }
GtLMethodCompilationResultExamples >> methodCompilationResultCreation [
	<gtExample>
	| oldMethod newMethod targetMethodReference result |
	oldMethod := GtLMethodWithSource new
		methodReference: (GtLMethodReference new
			methodClassName: 'SampleClass';
			methodName: 'sampleMethod';
			classSide: false;
			yourself);
		sourceCode: 'sampleMethod ^ 1';
		yourself.
	newMethod := GtLMethodWithSource new
		methodReference: (GtLMethodReference new
			methodClassName: 'SampleClass';
			methodName: 'sampleMethod';
			classSide: false;
			yourself);
		sourceCode: 'sampleMethod ^ 2';
		yourself.
	targetMethodReference := GtLMethodReference new
		methodClassName: 'SampleClass';
		methodName: 'sampleMethod';
		classSide: false;
		yourself.
	result := GtLMethodCompilationResult new
		oldMethod: oldMethod;
		newMethod: newMethod;
		status: 'compiled';
		yourself.
	self assert: result status equals: 'compiled'.
	self assert: result oldMethod sourceCode equals: 'sampleMethod ^ 1'.
	self assert: result newMethod sourceCode equals: 'sampleMethod ^ 2'.
	self assert: result targetMethodReference equals: targetMethodReference.
	self assertResultIsMethod: result.
	self assertResultIsMethodModification: result.
	^ result
]

{ #category : #examples }
GtLMethodCompilationResultExamples >> methodCompilationResultDataViewSerialization [
	<gtExample>
	<return: #GtLPrimitiveMessageDataBlock>
	| domainObject compositeView dataBlock jsonData targetMethodReference expectedJson expectedTargetMethodReference |
	domainObject := self methodCompilationResultCreation.

	compositeView := domainObject llmDataViewsFor: GtLDataView new.
	self assert: compositeView dataViews size equals: 1.

	dataBlock := compositeView serializeToLlmPrimiteData.
	self assertDataBlockHasOnlyJsonData: dataBlock.

	jsonData := dataBlock compositeJsonData.
	targetMethodReference := jsonData at: #targetMethodReference.
	expectedTargetMethodReference := targetMethodReference class new
		at: 'methodName' put: 'sampleMethod';
		at: 'methodClassName' put: 'SampleClass';
		at: 'classSide' put: false;
		yourself.
	expectedJson := jsonData class new
		at: #status put: 'compiled';
		at: #targetMethodReference put: expectedTargetMethodReference;
		yourself.
	self assert: jsonData equals: expectedJson.

	^ dataBlock
]

{ #category : #examples }
GtLMethodCompilationResultExamples >> methodCompilationResultMethodAddition [
	<gtExample>
	| newMethod targetMethodReference result |
	newMethod := GtLMethodWithSource new
		methodReference: (GtLMethodReference new
			methodClassName: 'SampleClass';
			methodName: 'addedMethod';
			classSide: false;
			yourself);
		sourceCode: 'addedMethod ^ 42';
		yourself.
	targetMethodReference := GtLMethodReference new
		methodClassName: 'SampleClass';
		methodName: 'addedMethod';
		classSide: false;
		yourself.
	result := GtLMethodCompilationResult new
		oldMethod: nil;
		newMethod: newMethod;
		status: 'compiled';
		yourself.
	self assert: result oldMethod isNil.
	self assert: result newMethod sourceCode equals: 'addedMethod ^ 42'.
	self assert: result targetMethodReference equals: targetMethodReference.
	self assert: result status equals: 'compiled'.
	self assertResultIsMethod: result.
	self assertResultIsMethodAddition: result.
	^ result
]

{ #category : #examples }
GtLMethodCompilationResultExamples >> methodCompilationResultMethodAdditionDataViewSerialization [
	<gtExample>
	<return: #GtLPrimitiveMessageDataBlock>
	| domainObject compositeView dataBlock jsonData targetMethodReference expectedJson expectedTargetMethodReference |
	domainObject := self methodCompilationResultMethodAddition.

	compositeView := domainObject llmDataViewsFor: GtLDataView new.
	self assert: compositeView dataViews size equals: 1.

	dataBlock := compositeView serializeToLlmPrimiteData.
	self assertDataBlockHasOnlyJsonData: dataBlock.

	jsonData := dataBlock compositeJsonData.
	targetMethodReference := jsonData at: #targetMethodReference.
	expectedTargetMethodReference := targetMethodReference class new
		at: 'methodName' put: 'addedMethod';
		at: 'methodClassName' put: 'SampleClass';
		at: 'classSide' put: false;
		yourself.
	expectedJson := jsonData class new
		at: #status put: 'compiled';
		at: #targetMethodReference put: expectedTargetMethodReference;
		yourself.
	self assert: jsonData equals: expectedJson.

	^ dataBlock
]
