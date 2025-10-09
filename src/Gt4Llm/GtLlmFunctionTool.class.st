Class {
	#name : #GtLlmFunctionTool,
	#superclass : #GtLlmAbstractFunctionTool,
	#instVars : [
		'description',
		'parameters',
		'block',
		'name'
	],
	#category : #Gt4Llm
}

{ #category : #accessing }
GtLlmFunctionTool class >> leJsonV4Name [
	^ #gtLlmFunctionTool
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

{ #category : #accessing }
GtLlmFunctionTool >> description [
	^ description
]

{ #category : #accessing }
GtLlmFunctionTool >> description: anObject [
	description := anObject
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

{ #category : #views }
GtLlmFunctionTool >> gtMethodFor: aView [
	<gtView>
	self method ifNil: [ ^ aView empty ].
	^ aView forward
		title: 'Method';
		priority: 2;
		object: [ self method ];
		view: #gtSourceCodeFor:
]

{ #category : #initialization }
GtLlmFunctionTool >> initialize [
	super initialize.

	name := ''.
	parameters := {}.
	description := ''
]

{ #category : #accessing }
GtLlmFunctionTool >> method [
	| split class methodName |
	self name ifNil: [ ^ nil ].

	split := '_' split: self name.
	class := split first asClassIfAbsent: [ ^ nil ].
	methodName := ':' join: split allButFirst.
	^ [ class >> methodName asSymbol ] on: Error do: [ nil ]
]

{ #category : #accessing }
GtLlmFunctionTool >> name [
	^ name
]

{ #category : #accessing }
GtLlmFunctionTool >> name: anObject [
	name := anObject
]

{ #category : #accessing }
GtLlmFunctionTool >> parameters [
	^ parameters
]

{ #category : #accessing }
GtLlmFunctionTool >> parameters: anObject [
	parameters := anObject
]

{ #category : #accessing }
GtLlmFunctionTool >> privatePerformToolCall: aGtLlmFunctionToolCall [
	| result |
	self
		assert: block isNotNil
		description: [ 'Trying to call a function without a block' ].
	self
		assert: aGtLlmFunctionToolCall arguments keys asSet = parameters asSet
		description: [ 'The arguments of the function call do not match the parameters of the tool' ].
	"Commented due to Gemstone:
	(GtLlmFunctionCallAboutToBePerformedSignal new
		tool: self;
		functionCall: aGtLlmFunctionToolCall) emit."
	result := block value: aGtLlmFunctionToolCall.
	"Commented due to Gemstone:
	(GtLlmFunctionCallPerformedSignal new
		tool: self;
		functionCall: aGtLlmFunctionToolCall) emit."
	^ result
]
