"
Examples for GtLClassRemovalResult domain object.
"
Class {
	#name : #GtLClassRemovalResultExamples,
	#superclass : #GtLMagritteDomainObjectExamples,
	#category : 'Gt4LlmCore-Examples-Domain Objects'
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
	result := self classRemovalResultCreation.
	jsonObject := GtMagritteJSONDataExporter exportObject: result.
	expected := NeoJSONObject new
		at: 'removedClassName' put: 'MyTestClass';
		at: 'status' put: 'removed';
		yourself.
	self assert: jsonObject equals: expected.
	^ jsonObject
]
