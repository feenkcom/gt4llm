"
Examples for GtLClassRemovalResult domain object.
"
Class {
	#name : #GtLClassRemovalResultExamples,
	#superclass : #GtLMagritteDomainObjectExamples,
	#category : #'Gt4LlmCore-Examples'
}

{ #category : #examples }
GtLClassRemovalResultExamples >> classRemovalResultCreation [
	<gtExample>
	| result |
	result := GtLClassRemovalResult new
		removedClassName: 'MyTestClass';
		status: 'removed';
		yourself.
	self assert: result removedClassName equals: 'MyTestClass'.
	self assert: result status equals: 'removed'.
	^ result
]

{ #category : #examples }
GtLClassRemovalResultExamples >> classRemovalResultSerialization [
	<gtExample>
	| result jsonObject expected |
	result := GtLClassRemovalResult new
		removedClassName: 'SampleClass';
		status: 'removed';
		yourself.
	jsonObject := GtMagritteJSONDataExporter exportObject: result.
	expected := NeoJSONObject new
		at: 'removedClassName' put: 'SampleClass';
		at: 'status' put: 'removed';
		yourself.
	self assert: jsonObject equals: expected.
	^ jsonObject
]
