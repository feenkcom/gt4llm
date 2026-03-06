"
Examples for GtLClassDescription.
"
Class {
	#name : #GtLClassDescriptionExamples,
	#superclass : #GtLMagritteDomainObjectExamples,
	#category : 'Gt4LlmCore-Examples-Domain Objects'
}

{ #category : #examples }
GtLClassDescriptionExamples >> classDescriptionCreation [
	<gtExample>
	| description |
	description := GtLClassDescription new
		currentClassName: 'SampleClass';
		superclassName: 'Object';
		comment: 'Sample';
		packageName: 'Samples';
		instanceSlotNames: #('a' 'b');
		classSlotNames: #('c');
		allInstanceMethodNames: #(foo bar:);
		allClassMethodNames: #(baz);
		yourself.
	self assert: description currentClassName equals: 'SampleClass'.
	self assert: description superclassName equals: 'Object'.
	self assert: description comment equals: 'Sample'.
	self assert: description packageName equals: 'Samples'.
	self assert: description instanceSlotNames equals: #('a' 'b').
	self assert: description classSlotNames equals: #('c').
	self assert: description allInstanceMethodNames equals: #(foo bar:).
	self assert: description allClassMethodNames equals: #(baz).
	^ description
]

{ #category : #examples }
GtLClassDescriptionExamples >> classDescriptionSerialization [
	<gtExample>
	| description jsonObject expected |
	description := GtLClassDescription new
		currentClassName: 'SampleClass';
		superclassName: 'Object';
		comment: 'Sample';
		packageName: 'Samples';
		instanceSlotNames: #('a' 'b');
		classSlotNames: #('c');
		allInstanceMethodNames: #(foo bar:);
		allClassMethodNames: #(baz);
		yourself.

	jsonObject := GtMagritteJSONDataExporter exportObject: description.
	expected := NeoJSONObject new
		at: 'currentClassName' put: description currentClassName;
		at: 'superclassName' put: description superclassName;
		at: 'comment' put: description comment;
		at: 'packageName' put: description packageName;
		at: 'instanceSlotNames' put: (NeoJSONArray withAll: description instanceSlotNames asArray);
		at: 'classSlotNames' put: (NeoJSONArray withAll: description classSlotNames asArray);
		at: 'allInstanceMethodNames'
			put: (NeoJSONArray withAll: description allInstanceMethodNames asArray);
		at: 'allClassMethodNames'
			put: (NeoJSONArray withAll: description allClassMethodNames asArray);
		yourself.
	self assert: jsonObject equals: expected.
	^ jsonObject
]

{ #category : #examples }
GtLClassDescriptionExamples >> fromClassDescription [
	<gtExample>
	| description aClass |
	aClass := GtLClassDescription.
	description := GtLClassDescription fromClass: aClass.
	self assert: description currentClassName equals: aClass name.
	self assert: description superclassName equals: aClass superclass name.
	self assert: description packageName equals: aClass package name.
	self assert: description instanceSlotNames equals: aClass slotNames.
	self assert: description classSlotNames equals: aClass class slotNames.
	self assert: (description allInstanceMethodNames includes: #currentClassNameDescription).
	self assert: (description allClassMethodNames includes: #fromClass:).
	^ description
]
