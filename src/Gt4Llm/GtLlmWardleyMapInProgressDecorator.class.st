Class {
	#name : #GtLlmWardleyMapInProgressDecorator,
	#superclass : #Object,
	#traits : 'TGtWardleyMapDecoratorModel',
	#classTraits : 'TGtWardleyMapDecoratorModel classTrait',
	#instVars : [
		'parent'
	],
	#category : #'Gt4Llm-Domain - Wardley Map'
}

{ #category : #accessing }
GtLlmWardleyMapInProgressDecorator >> decorateMapElementInContext: aMapDecoratorContext [
	| anElement anActionContainer |
	anActionContainer := GtWardleyMapUtility
			ensureTopLeftInnerDecoratorContainerFor: aMapDecoratorContext canvasElement.
	anElement := GtLlmWardleyMapInProgressElement new
			wardleyMapDecoratorViewModel: aMapDecoratorContext decoratorViewModel.
	anActionContainer addChild: anElement
]

{ #category : #accessing }
GtLlmWardleyMapInProgressDecorator >> parent: aParent [
	self assert: [ parent isNil ] description: [ 'Only one parent is allowed' ].

	parent := aParent
]

{ #category : #accessing }
GtLlmWardleyMapInProgressDecorator >> removeParent [
	parent := nil
]
