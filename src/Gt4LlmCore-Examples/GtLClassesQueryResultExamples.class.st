"
Examples for GtLClassesQueryResult.
"
Class {
	#name : #GtLClassesQueryResultExamples,
	#superclass : #GtLMagritteDomainObjectExamples,
	#category : #'Gt4LlmCore-Examples-Domain Objects'
}

{ #category : #examples }
GtLClassesQueryResultExamples >> classesQueryResultSerialization [
	<gtExample>
	| domainObject jsonObject expected |
	domainObject := self classesQueryResultWithMatches.
	jsonObject := GtMagritteJSONDataExporter exportObject: domainObject.
	expected := NeoJSONObject new
		at: 'query' put: domainObject query;
		at: 'foundClassNames'
			put: (NeoJSONArray withAll: domainObject foundClassNames asArray);
		at: 'mayHaveMore' put: domainObject mayHaveMore;
		yourself.
	self assert: jsonObject equals: expected.
	^ jsonObject
]

{ #category : #examples }
GtLClassesQueryResultExamples >> classesQueryResultWithMatches [
	<gtExample>
	| result |
	result := GtLClassesQueryResult new
		query: 'Sample';
		foundClassNames: { 'A'. 'B' };
		mayHaveMore: true;
		yourself.
	self assert: result query equals: 'Sample'.
	self assert: result foundClassNames size equals: 2.
	self assert: result mayHaveMore.
	^ result
]
