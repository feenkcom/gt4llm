Class {
	#name : #GtLlmFunctionTool,
	#superclass : #GtLlmTool,
	#instVars : [
		'description',
		'parameters',
		'block'
	],
	#category : #Gt4Llm
}

{ #category : #accessing }
GtLlmFunctionTool class >> leJsonV4Name [

	^ #gtLlmFunctionTool
]

{ #category : #'as yet unclassified' }
GtLlmFunctionTool class >> serializationProperties [
	^ {#type -> #type. #function -> #function}
]

{ #category : #visiting }
GtLlmFunctionTool >> acceptVisitor: aVisitor [

	^ aVisitor visitGtLlmFunctionTool: self
]

{ #category : #accessing }
GtLlmFunctionTool >> block [
	^ block
]

{ #category : #accessing }
GtLlmFunctionTool >> block: anObject [
	block := anObject
]

{ #category : #'as yet unclassified' }
GtLlmFunctionTool >> defaultType [
	^ 'function'
]

{ #category : #accessing }
GtLlmFunctionTool >> description [
	^ description
]

{ #category : #accessing }
GtLlmFunctionTool >> description: anObject [
	description := anObject
]

{ #category : #accessing }
GtLlmFunctionTool >> function [
	^ {'name' -> name.
		'description' -> self description.
		'parameters'
			-> {'type' -> 'object'.
					'properties'
						-> (parameters collect: [ :aName | aName -> {'type' -> 'string'} asDictionary ])
								asDictionary.
					'required' -> parameters.
					'additionalProperties' -> false} asDictionary.
		'strict' -> true} asDictionary
]

{ #category : #accessing }
GtLlmFunctionTool >> functionResponse [
	^ {'name' -> name.
		'type' -> type.
		'description' -> description.
		'parameters'
			-> {'type' -> 'object'.
					'properties'
						-> (parameters collect: [ :aName | aName -> {'type' -> 'string'} asDictionary ])
								asDictionary.
					'required' -> parameters.
					'additionalProperties' -> false} asDictionary} asDictionary
]

{ #category : #views }
GtLlmFunctionTool >> gtBlockSourceCodeFor: aView [
	<gtView>
	^ aView forward
		title: 'Source code';
		object: [ block ];
		view: #gtSourceCodeFor:
]

{ #category : #views }
GtLlmFunctionTool >> gtFunctionFor: aView [
	<gtView>
	^ aView forward
		title: 'Function';
		priority: 1;
		object: [ self function ];
		view: #gtItemsFor:
]

{ #category : #'as yet unclassified' }
GtLlmFunctionTool >> gtMethodFor: aView [
	<gtView>
	self method ifNil: [ ^ aView empty ].
	^ aView forward
		title: 'Method';
		priority: 2;
		object: [ self method ];
		view: #gtSourceCodeFor:
]

{ #category : #'as yet unclassified' }
GtLlmFunctionTool >> initialize [
	super initialize.

	name := ''.
	parameters := {}.
	description := ''
]

{ #category : #'as yet unclassified' }
GtLlmFunctionTool >> method [
	| split class methodName |
	name ifNil: [ ^ nil ].

	split := '_' split: name.
	class := split first asClassIfAbsent: [ ^ nil ].
	methodName := ':' join: split allButFirst.
	^ [ class >> methodName asSymbol ] on: Error do: [ nil ]
]

{ #category : #accessing }
GtLlmFunctionTool >> parameters [
	^ parameters
]

{ #category : #accessing }
GtLlmFunctionTool >> parameters: anObject [
	parameters := anObject
]

{ #category : #'as yet unclassified' }
GtLlmFunctionTool >> performToolCall: aGtLlmFunctionToolCall [
	| result |
	self
		assert: block isNotNil
		description: [ 'Trying to call a function without a block' ].
	self
		assert: aGtLlmFunctionToolCall arguments keys asSet = parameters asSet
		description: [ 'The arguments of the function call do not match the parameters of the tool' ].	"Commented due to Gemstone:
	(GtLlmFunctionCallAboutToBePerformedSignal new
		tool: self;
		functionCall: aGtLlmFunctionToolCall) emit."
	result := block value: aGtLlmFunctionToolCall.
	aGtLlmFunctionToolCall performedByTool: self.	"Commented due to Gemstone:
	(GtLlmFunctionCallPerformedSignal new
		tool: self;
		functionCall: aGtLlmFunctionToolCall) emit."
	^ result
]
