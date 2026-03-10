"
Examples for GtLMethodRemovalResult domain object.
"
Class {
	#name : #GtLMethodRemovalResultExamples,
	#superclass : #GtLMagritteDomainObjectExamples,
	#category : #'Gt4LlmCore-Examples-Domain Objects'
}

{ #category : #examples }
GtLMethodRemovalResultExamples >> methodRemovalResultCreation [
	<gtExample>
	| methodWithSource result |
	methodWithSource := GtLMethodWithSource new
		methodReference: (GtLMethodReference new
			methodClassName: 'SampleClass';
			methodName: 'sampleMethod';
			classSide: false;
			yourself);
		sourceCode: 'sampleMethod ^ 42';
		yourself.
	result := GtLMethodRemovalResult new
		removedMethod: methodWithSource;
		status: 'removed';
		yourself.
	self assert: result status equals: 'removed'.
	self assert: result removedMethod methodName equals: 'sampleMethod'.
	self assert: result removedMethod methodClassName equals: 'SampleClass'.
	self assert: result removedMethod sourceCode equals: 'sampleMethod ^ 42'.
	^ result
]

{ #category : #examples }
GtLMethodRemovalResultExamples >> methodRemovalResultSerialization [
	<gtExample>
	| result jsonObject expected |
	result := self methodRemovalResultCreation.
	jsonObject := GtMagritteJSONDataExporter exportObject: result.
	expected := NeoJSONObject new
		at: 'status' put: 'removed';
		yourself.
	self assert: jsonObject equals: expected.
	^ jsonObject
]
