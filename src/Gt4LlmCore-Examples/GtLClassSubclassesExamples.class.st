"
Examples for GtLClassSubclasses.
"
Class {
	#name : #GtLClassSubclassesExamples,
	#superclass : #GtLMagritteDomainObjectExamples,
	#category : #'Gt4LlmCore-Examples-Domain Objects'
}

{ #category : #examples }
GtLClassSubclassesExamples >> classSubclassesDomainObject [
	<gtExample>
	| result |
	result := GtLClassSubclasses new
		givenClassName: 'SampleClass';
		subclassNames: { 'A'. 'B' };
		mayHaveMore: true;
		yourself.
	self assert: result givenClassName equals: 'SampleClass'.
	self assert: result subclassNames size equals: 2.
	self assert: result mayHaveMore.
	^ result
]

{ #category : #examples }
GtLClassSubclassesExamples >> classSubclassesDomainObjectSerialization [
	<gtExample>
	| domainObject jsonObject |
	domainObject := self classSubclassesDomainObject.
	jsonObject := GtMagritteJSONDataExporter exportObject: domainObject.
	self
		assert: jsonObject
		equals: (NeoJSONObject new
			at: 'subclassNames' put: (NeoJSONArray with: 'A' with: 'B');
			at: 'givenClassName' put: 'SampleClass';
			at: 'mayHaveMore' put: true;
			yourself).
	^ jsonObject
]
