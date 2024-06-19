Class {
	#name : #GtLlmWardleyMapInProgressDecorator,
	#superclass : #Object,
	#traits : 'TGtWardleyMapDecoratorModel',
	#classTraits : 'TGtWardleyMapDecoratorModel classTrait',
	#instVars : [
		'parent'
	],
	#category : #'Gt4Llm-Examples - Wardley Map'
}

{ #category : #accessing }
GtLlmWardleyMapInProgressDecorator >> decorateMapElement: aMapElement decoratorViewModel: aDecoratorViewModel [
	BlTaskAction
		enqueueElement: aMapElement
		action: [ GtLlmWardleyMapInProgressManager new
				element: aMapElement;
				viewModel: aDecoratorViewModel;
				attach ]
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
