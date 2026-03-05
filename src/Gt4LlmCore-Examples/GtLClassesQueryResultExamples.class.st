"
Examples for GtLClassesQueryResult.
"
Class {
	#name : #GtLClassesQueryResultExamples,
	#superclass : #GtLMagritteDomainObjectExamples,
	#category : #'Gt4LlmCore-Examples'
}

{ #category : #examples }
GtLClassesQueryResultExamples >> classesQueryResultSerialization [
	<gtExample>
	| domainObject jsonObject |
	domainObject := self classesQueryResultWithMatches.
	jsonObject := GtMagritteJSONDataExporter exportObject: domainObject.
	self assert: (jsonObject at: 'query') equals: domainObject query.
	self assert: (jsonObject at: 'foundClassNames') asArray equals: domainObject foundClassNames.
	self assert: (jsonObject at: 'mayHaveMore') equals: domainObject mayHaveMore.
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
