"
Examples for GtLClassesSearchResult.
"
Class {
	#name : #GtLClassesSearchResultExamples,
	#superclass : #GtLMagritteDomainObjectExamples,
	#category : #'Gt4LlmCore-Examples'
}

{ #category : #examples }
GtLClassesSearchResultExamples >> classesSearchResultSerialization [
	<gtExample>
	| domainObject jsonObject expected |
	domainObject := self classesSearchResultWithMatches.
	jsonObject := GtMagritteJSONDataExporter exportObject: domainObject.
	expected := NeoJSONObject new
		at: 'foundClassNames'
			put: (NeoJSONArray withAll: #('A' 'B'));
		at: 'mayHaveMore' put: true;
		yourself.
	self assert: jsonObject equals: expected.
	^ jsonObject
]

{ #category : #examples }
GtLClassesSearchResultExamples >> classesSearchResultWithMatches [
	<gtExample>
	| result |
	result := GtLClassesSearchResult new
		foundClassNames: { 'A'. 'B' };
		mayHaveMore: true;
		yourself.
	self assert: result foundClassNames size equals: 2.
	self assert: result mayHaveMore.
	^ result
]
