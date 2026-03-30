"
Examples for GtLClassReferences.
"
Class {
	#name : #GtLClassReferencesExamples,
	#superclass : #GtLMagritteDomainObjectExamples,
	#category : 'Gt4LlmCore-Examples-Domain Objects'
}

{ #category : #examples }
GtLClassReferencesExamples >> classReferencesCreation [
	<gtExample>
	| reference result |
	reference := GtLMethodReference fromCompiledMethod: (GtLMagritteToolForClassReferences >> #name).
	result := GtLClassReferences new
		givenClassName: 'GtLMagritteToolForClassReferences';
		references: { reference };
		mayHaveMore: true;
		yourself.
	self assert: result givenClassName equals: 'GtLMagritteToolForClassReferences'.
	self assert: result references size equals: 1.
	self assert: result mayHaveMore.
	^ result
]

{ #category : #examples }
GtLClassReferencesExamples >> classReferencesSerialization [
	<gtExample>
	| domainObject jsonObject expected referenceJson |
	domainObject := self classReferencesCreation.
	jsonObject := GtMagritteJSONDataExporter exportObject: domainObject.
	referenceJson := NeoJSONObject new
		at: 'methodName' put: 'name';
		at: 'methodClassName' put: 'GtLMagritteToolForClassReferences';
		at: 'classSide' put: false;
		yourself.
	expected := NeoJSONObject new
		at: 'givenClassName' put: 'GtLMagritteToolForClassReferences';
		at: 'references' put: (NeoJSONArray with: referenceJson);
		at: 'mayHaveMore' put: true;
		yourself.
	self assert: jsonObject equals: expected.
	^ jsonObject
]
