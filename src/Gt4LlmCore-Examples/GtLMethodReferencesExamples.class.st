"
Examples for GtLMethodReferences.
"
Class {
	#name : #GtLMethodReferencesExamples,
	#superclass : #GtLMagritteDomainObjectExamples,
	#category : #'Gt4LlmCore-Examples'
}

{ #category : #examples }
GtLMethodReferencesExamples >> methodReferencesCreation [
	<gtExample>
	| references result |
	references := { GtLMagritteToolForMethodReferences >> #name }.
	result := GtLMethodReferences fromReferences: references.
	self assert: result methods size equals: 1.
	self assert: result methods first methodName equals: #name.
	self assert: result mayHaveMore not.
	^ result
]

{ #category : #examples }
GtLMethodReferencesExamples >> methodReferencesSerialization [
	<gtExample>
	| domainObject jsonObject expected referenceJson |
	domainObject := self methodReferencesCreation.
	jsonObject := GtMagritteJSONDataExporter exportObject: domainObject.
	referenceJson := NeoJSONObject new
		at: 'methodName' put: 'name';
		at: 'methodClassName' put: 'GtLMagritteToolForMethodReferences';
		at: 'classSide' put: false;
		yourself.
	expected := NeoJSONObject new
		at: 'methods' put: (NeoJSONArray with: referenceJson);
		at: 'mayHaveMore' put: false;
		yourself.
	self assert: jsonObject equals: expected.
	^ jsonObject
]
