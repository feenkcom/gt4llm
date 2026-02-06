Class {
	#name : #GtLlmValueSerializerExamples,
	#superclass : #Object,
	#category : 'Gt4Llm-GToolkit-Examples'
}

{ #category : #'as yet unclassified' }
GtLlmValueSerializerExamples >> serializeClass [
	<gtExample>
	| serializer result slots methods comment |
	serializer := GtLlmValueSerializer new.
	result := serializer serializeClass: GtLlmValueSerializerExamples.

	self assert: (result isKindOf: Dictionary).
	self
		assert: (result keys
				includesAll: #('class' 'superclass' 'comment' 'package' 'instanceSlots' 'allInstanceMethods')).
	self
		assert: (result at: 'class') asString = GtLlmValueSerializerExamples name asString.
	self
		assert: (result at: 'superclass') asString
				= GtLlmValueSerializerExamples superclass name asString.
	self
		assert: (result at: 'package') asString
				= GtLlmValueSerializerExamples package name asString.

	slots := (result at: 'instanceSlots') collect: #asString.
	methods := result at: 'allInstanceMethods'.

	self assert: slots isCollection.
	self assert: (methods includesAll: GtLlmValueSerializerExamples selectors).

	comment := result at: 'comment'.
	self assert: (comment isNil or: [ comment isString ]).

	^ serializer
]

{ #category : #'as yet unclassified' }
GtLlmValueSerializerExamples >> serializeValue [
	<gtExample>
	| serializer value result |
	serializer := GtLlmValueSerializer new.
	value := GtLlmValueSerializerExamples new.
	result := serializer serializeValue: value.

	self assert: (result isKindOf: Dictionary).
	self assert: (result keys includesAll: #('class' 'superclass' 'package' 'printString' 'allInstanceMethods' 'instanceSlots')).
	self assert: ((result at: 'class') asString) = value class name asString.
	self assert: ((result at: 'superclass') asString) = value class superclass name asString.
	self assert: ((result at: 'printString') asString) = value printString.
	self assert: ((result at: 'allInstanceMethods') includesAll: GtLlmValueSerializerExamples selectors).
	self assert: ((result at: 'instanceSlots') isCollection).

	^ serializer
]
