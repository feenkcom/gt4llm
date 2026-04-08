"
Examples for GtLMethodCompilationResult domain object.
"
Class {
	#name : #GtLMethodCompilationResultExamples,
	#superclass : #GtLMagritteDomainObjectExamples,
	#category : #'Gt4LlmCore-Examples-Domain Objects'
}

{ #category : #examples }
GtLMethodCompilationResultExamples >> methodCompilationResultCreation [
	<gtExample>
	| oldMethod newMethod result |
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
	result := GtLMethodCompilationResult new
		oldMethod: oldMethod;
		newMethod: newMethod;
		status: 'compiled';
		yourself.
	self assert: result status equals: 'compiled'.
	self assert: result oldMethod sourceCode equals: 'sampleMethod ^ 1'.
	self assert: result newMethod sourceCode equals: 'sampleMethod ^ 2'.
	^ result
]

{ #category : #examples }
GtLMethodCompilationResultExamples >> methodCompilationResultDataViewSerialization [
	<gtExample>
	<return: #GtLPrimitiveMessageDataBlock>
	| domainObject compositeView dataBlock jsonData expectedJson |
	domainObject := self methodCompilationResultCreation.
	
	compositeView := domainObject llmDataViewsFor: GtLDataView new.
	self assert: compositeView dataViews size equals: 1.
	
	dataBlock := compositeView serializeToLlmPrimiteData.
	self assert: dataBlock dataBlocks size equals: 1.
	self assert: dataBlock imageDataBlocks isEmpty.
	
	jsonData := dataBlock compositeJsonData.
	expectedJson := {
		#status -> 'compiled'
	} asDictionary.
	self assert: jsonData equals: expectedJson.
	
	^ dataBlock
]

{ #category : #examples }
GtLMethodCompilationResultExamples >> methodCompilationResultSerialization [
	<gtExample>
	| result jsonObject expected |
	result := self methodCompilationResultCreation.
	jsonObject := GtMagritteJSONDataExporter exportObject: result.
	expected := NeoJSONObject new
		at: 'status' put: 'compiled';
		yourself.
	self assert: jsonObject equals: expected.
	^ jsonObject
]
