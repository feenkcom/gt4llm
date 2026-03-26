"
Examples for GtLClassesSearchResult.
"
Class {
	#name : #GtLClassesSearchResultExamples,
	#superclass : #GtLMagritteDomainObjectExamples,
	#category : 'Gt4LlmCore-Examples-Domain Objects'
}

{ #category : #examples }
GtLClassesSearchResultExamples >> classesSearchResultSerialization [
	<gtExample>
	| domainObject jsonObject expected |
	domainObject := self classesSearchResultWithMatches.
	jsonObject := GtMagritteJSONDataExporter exportObject: domainObject.
	expected := NeoJSONObject new
		at: 'foundClassNames'
			put: (NeoJSONArray withAll: #('Object' 'String'));
		at: 'mayHaveMore' put: false;
		yourself.
	self assert: jsonObject equals: expected.
	^ jsonObject
]

{ #category : #examples }
GtLClassesSearchResultExamples >> classesSearchResultWithMatches [
	<gtExample>
	| matches result |
	matches := { Object. String }.
	result := GtLClassesSearchResult fromClasses: matches.
	self assert: result foundClassNames equals: #('Object' 'String').
	self assert: result mayHaveMore not.
	^ result
]
