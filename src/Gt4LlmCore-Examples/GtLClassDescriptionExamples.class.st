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
	<return: #GtLCompositeDataBlock>
	| description compositeView dataBlock jsonData expectedJson |
	description := GtLClassDescription new
		currentClassName: 'SampleClass';
		superclassName: 'Object';
		comment: 'Sample';
		packageName: 'Samples';
		packageTagName: 'SampleTag';
		instanceSlotNames: #('a' 'b');
		classSlotNames: #('c');
		allInstanceMethodNames: #('foo' 'bar:');
		allClassMethodNames: #('baz');
		yourself.

	compositeView := description llmDataViewsFor: GtLDataView new.
	self assert: compositeView dataViews size equals: 1.
	
	dataBlock := compositeView serializeToLlmPrimiteData.
	self assert: dataBlock isNotNil.
	self assert: dataBlock dataBlocks size equals: 1.
	self assert: dataBlock imageDataBlocks isEmpty.
	
	jsonData := dataBlock compositeJsonData.
	expectedJson := {
		#currentClassName -> 'SampleClass'.
		#superclassName -> 'Object'.
		#comment -> 'Sample'.
		#packageName -> 'Samples'.
		#packageTagName -> 'SampleTag'.
		#instanceSlotNames -> (NeoJSONArray withAll: #('a' 'b')).
		#classSlotNames -> (NeoJSONArray withAll: #('c')).
		#allInstanceMethodNames -> (NeoJSONArray withAll: #('foo' 'bar:')).
		#allClassMethodNames -> (NeoJSONArray withAll: #('baz'))
	} asDictionary.
	self assert: jsonData equals: expectedJson.
	
	^ dataBlock
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
