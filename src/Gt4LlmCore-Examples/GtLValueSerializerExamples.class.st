Class {
	#name : #GtLValueSerializerExamples,
	#superclass : #Object,
	#category : #'Gt4LlmCore-Examples-Support'
}

{ #category : #examples }
GtLValueSerializerExamples >> basicSerializer [
	<gtExample>
	^ GtLValueSerializer new
]

{ #category : #examples }
GtLValueSerializerExamples >> dummyClassOne [
	<gtExample>
	^ GtLDummyOneObject
]

{ #category : #examples }
GtLValueSerializerExamples >> serializeDummyClassOne [
	<gtExample>
	| aSerializer aClass aResult |
	aSerializer := self basicSerializer.
	aClass := self dummyClassOne.
	aResult := aSerializer serializeClass: aClass.
	^ GtLValueSerializerResult new
		serializer: aSerializer;
		input: aClass;
		output: aResult
]

{ #category : #examples }
GtLValueSerializerExamples >> serializeProtoObjectClass [
	<gtExample>
	| aSerializer aClass aResult |
	aSerializer := self basicSerializer.
	aClass := ProtoObject.
	aResult := aSerializer serializeClass: aClass.
	^ GtLValueSerializerResult new
		serializer: aSerializer;
		input: aClass;
		output: aResult;
		inputViewAsClassCoder
]

{ #category : #examples }
GtLValueSerializerExamples >> validateBrokenDummyClassOne [
	<gtExample>
	| aSerializer aJson aResult |
	aResult := self serializeDummyClassOne.
	aSerializer := aResult serializer.
	aJson := aResult output.
	aJson := aJson copy.
	aJson removeKey: #class.
	aResult := aSerializer validateClass: aJson.
	
	self assert: aResult isValid not.
	
	^ GtLValueSerializerResult new
		serializer: aSerializer;
		input: aJson;
		output: aResult;
		outputWithValidatorDetails
]

{ #category : #examples }
GtLValueSerializerExamples >> validateDummyClassOne [
	<gtExample>
	| aSerializer aJson aResult |
	aResult := self serializeDummyClassOne.
	aSerializer := aResult serializer.
	aJson := aResult output.
	aResult := aSerializer validateClass: aJson.
	
	self assert: aResult isValid.
	
	^ GtLValueSerializerResult new
		serializer: aSerializer;
		input: aJson;
		output: aResult;
		outputWithValidatorDetails
]

{ #category : #examples }
GtLValueSerializerExamples >> validateProtonObject [
	<gtExample>
	| aSerializer aJson aResult |
	aResult := self serializeProtoObjectClass.
	aSerializer := aResult serializer.
	aJson := aResult output.
	aResult := aSerializer validateClass: aJson.

	self assert: aResult isValid.

	^ GtLValueSerializerResult new
		serializer: aSerializer;
		input: aJson;
		output: aResult;
		outputWithValidatorDetails
]
