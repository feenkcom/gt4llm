Class {
	#name : #GtLFunctionTool,
	#superclass : #GtLAbstractPlainSchemaFunctionTool,
	#instVars : [
		'description',
		'block',
		'name',
		'parametersDescription'
	],
	#category : 'Gt4LlmCore-Tools'
}

{ #category : #visiting }
GtLFunctionTool >> acceptVisitor: aVisitor [
	^ aVisitor visitGtLlmFunctionTool: self
]

{ #category : #accessing }
GtLFunctionTool >> block [
	^ block
]

{ #category : #accessing }
GtLFunctionTool >> block: anObject [
	block := anObject
]

{ #category : #accessing }
GtLFunctionTool >> description [
	^ description
]

{ #category : #accessing }
GtLFunctionTool >> description: anObject [
	description := anObject
]

{ #category : #views }
GtLFunctionTool >> gtBlockSourceCodeFor: aView [
	<gtView>
	^ aView forward
		title: 'Source code';
		object: [ block ];
		view: #gtSourceCodeFor:
]

{ #category : #views }
GtLFunctionTool >> gtFunctionFor: aView [
	<gtView>
	^ aView forward
		title: 'Function';
		priority: 1;
		object: [ self function ];
		view: #gtItemsFor:
]

{ #category : #views }
GtLFunctionTool >> gtMethodFor: aView [
	<gtView>
	self method ifNil: [ ^ aView empty ].
	^ aView forward
		title: 'Method';
		priority: 2;
		object: [ self method ];
		view: #gtSourceCodeFor:
]

{ #category : #initialization }
GtLFunctionTool >> initialize [
	super initialize.

	name := ''.
	parametersDescription := {}.
	description := ''
]

{ #category : #accessing }
GtLFunctionTool >> method [
	| split class methodName |
	self name ifNil: [ ^ nil ].

	split := '_' split: self name.
	class := split first asClassIfAbsent: [ ^ nil ].
	methodName := ':' join: split allButFirst.
	^ [ class >> methodName asSymbol ] on: Error do: [ nil ]
]

{ #category : #accessing }
GtLFunctionTool >> name [
	^ name
]

{ #category : #accessing }
GtLFunctionTool >> name: anObject [
	name := anObject
]

{ #category : #accessing }
GtLFunctionTool >> parameters: anObject [
	self parametersDescription: anObject
]

{ #category : #accessing }
GtLFunctionTool >> parametersDescription [
	^ parametersDescription
]

{ #category : #accessing }
GtLFunctionTool >> parametersDescription: anObject [
	parametersDescription := anObject
]

{ #category : #accessing }
GtLFunctionTool >> privatePerformToolCall: aGtLFunctionToolCall [
	| result |
	self
		assert: block isNotNil
		description: [ 'Trying to call a function without a block' ].
	self
		assert: aGtLFunctionToolCall arguments keys size = parametersDescription size
		description: [ 'The arguments of the function call do not match the parameters of the tool' ].
	"Commented due to Gemstone:
	(GtLlmFunctionCallAboutToBePerformedSignal new
		tool: self;
		functionCall: aGtLlmFunctionToolCall) emit."
	result := block value: aGtLFunctionToolCall.
	"Commented due to Gemstone:
	(GtLlmFunctionCallPerformedSignal new
		tool: self;
		functionCall: aGtLlmFunctionToolCall) emit."
	^ GtLValueDomainObject new value: result
]
