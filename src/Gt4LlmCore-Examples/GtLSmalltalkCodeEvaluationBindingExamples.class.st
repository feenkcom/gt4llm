"
Examples for GtLSmalltalkCodeEvaluationBinding domain object.
"
Class {
	#name : #GtLSmalltalkCodeEvaluationBindingExamples,
	#superclass : #GtLDomainObjectExamples,
	#category : #'Gt4LlmCore-Examples-Domain Objects'
}

{ #category : #examples }
GtLSmalltalkCodeEvaluationBindingExamples >> bindingCreation [
	<gtExample>
	| binding |
	binding := GtLSmalltalkCodeEvaluationBinding new
		name: 'myVar';
		objectId: 'abc-123';
		yourself.
	
	self assert: binding name equals: 'myVar'.
	self assert: binding objectId equals: 'abc-123'.
	
	^ binding
]

{ #category : #examples }
GtLSmalltalkCodeEvaluationBindingExamples >> bindingSerialization [
	<gtExample>
	| binding jsonObject expected |
	binding := self bindingCreation.
	jsonObject := GtMagritteJSONDataExporter exportObject: binding.
	
	expected := NeoJSONObject new
		at: 'name' put: 'myVar';
		at: 'objectId' put: 'abc-123';
		yourself.
	
	self assert: jsonObject equals: expected.
	
	^ jsonObject
]
