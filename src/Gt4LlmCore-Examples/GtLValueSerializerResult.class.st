Class {
	#name : #GtLValueSerializerResult,
	#superclass : #Object,
	#instVars : [
		'serializer',
		'input',
		'output',
		'inputViewStencilBuilder',
		'outputViewStencilBuilder'
	],
	#category : 'Gt4LlmCore-Examples-Support'
}

{ #category : #'gt - extensions' }
GtLValueSerializerResult >> gtInputViewFor: aView context: aContext [
	<gtView>
	| aNewView |
	aNewView := inputViewStencilBuilder
			object: self input;
			originalView: aView;
			context: aContext;
			build.

	aNewView
		priority: 2;
		title: 'Input'.
	^ aNewView
]

{ #category : #'gt - extensions' }
GtLValueSerializerResult >> gtOutputViewFor: aView context: aContext [
	<gtView>
	| aNewView |
	aNewView := outputViewStencilBuilder
			object: self output;
			originalView: aView;
			context: aContext;
			build.

	aNewView
		priority: 1;
		title: 'Output'.
	^ aNewView
]

{ #category : #initialization }
GtLValueSerializerResult >> initialize [
	super initialize.

	inputViewStencilBuilder := GtLValueSerializerResultViewStencilBuilder new.
	outputViewStencilBuilder := GtLValueSerializerResultViewStencilBuilder new
]

{ #category : #accessing }
GtLValueSerializerResult >> input [
	^ input
]

{ #category : #accessing }
GtLValueSerializerResult >> input: anObject [
	input := anObject
]

{ #category : #'api - initialization' }
GtLValueSerializerResult >> inputViewAsClassCoder [
	self inputViewStencilBuilder: [ :aClass :aView :aContext |
		aView explicit stencil: [ GtClassCoderTool forClass: aClass ] ]
]

{ #category : #'api - initialization' }
GtLValueSerializerResult >> inputViewStencilBuilder: aStencilBuilder [
	inputViewStencilBuilder := aStencilBuilder
			asStencilBuilder: GtLValueSerializerResultViewStencilBuilder
]

{ #category : #accessing }
GtLValueSerializerResult >> output [
	^ output
]

{ #category : #accessing }
GtLValueSerializerResult >> output: anObject [
	output := anObject
]

{ #category : #'api - initialization' }
GtLValueSerializerResult >> outputViewStencilBuilder: aStencilBuilder [
	outputViewStencilBuilder := aStencilBuilder
			asStencilBuilder: GtLValueSerializerResultViewStencilBuilder
]

{ #category : #'api - initialization' }
GtLValueSerializerResult >> outputWithValidatorDetails [
	self
		outputViewStencilBuilder: [ :anObject :aView :aContext | 
			aView forward
				object: [ anObject ];
				view: #gtViewDetailsIn: ]
]

{ #category : #accessing }
GtLValueSerializerResult >> serializer [
	^ serializer
]

{ #category : #accessing }
GtLValueSerializerResult >> serializer: anObject [
	serializer := anObject
]
