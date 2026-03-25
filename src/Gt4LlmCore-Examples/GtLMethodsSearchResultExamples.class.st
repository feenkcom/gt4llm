"
Examples for GtLMethodsSearchResult.
"
Class {
	#name : #GtLMethodsSearchResultExamples,
	#superclass : #GtLMagritteDomainObjectExamples,
	#category : 'Gt4LlmCore-Examples-Domain Objects'
}

{ #category : #examples }
GtLMethodsSearchResultExamples >> methodsSearchResultCreation [
	<gtExample>
	| references result |
	references := { GtLToolForMethodReferences >> #name }.
	result := GtLMethodsSearchResult fromReferences: references.
	self assert: result foundMethods size equals: 1.
	self assert: result foundMethods first methodName equals: #name.
	self assert: result mayHaveMore not.
	^ result
]

{ #category : #examples }
GtLMethodsSearchResultExamples >> methodsSearchResultSerialization [
	<gtExample>
	| domainObject jsonObject expected referenceJson |
	domainObject := self methodsSearchResultCreation.
	jsonObject := GtMagritteJSONDataExporter exportObject: domainObject.
	referenceJson := NeoJSONObject new
		at: 'methodName' put: 'name';
		at: 'methodClassName' put: 'GtLToolForMethodReferences';
		at: 'classSide' put: false;
		yourself.
	expected := NeoJSONObject new
		at: 'foundMethods' put: (NeoJSONArray with: referenceJson);
		at: 'mayHaveMore' put: false;
		yourself.
	self assert: jsonObject equals: expected.
	^ jsonObject
]
