Class {
	#name : #GtLlmWardleyMapInProgressDecorator,
	#superclass : #Object,
	#traits : 'TGtWardleyMapDecoratorModel',
	#classTraits : 'TGtWardleyMapDecoratorModel classTrait',
	#instVars : [
		'parent',
		'addedChildren'
	],
	#category : #'Gt4Llm-Examples - Wardley Map'
}

{ #category : #accessing }
GtLlmWardleyMapInProgressDecorator >> decorateMapElement: aMapElement decoratorViewModel: aDecoratorViewModel [
	BlTaskAction
		enqueueElement: aMapElement
		action: [ | addedChild |
			addedChild := BrHorizontalPane new fitContent
					padding: (BlInsets all: 5);
					addChild: BrGlamorousVectorIcons refresh asElement;
					addChild: (BrLabel new
							aptitude: BrGlamorousLabelAptitude new glamorousCodeFontAndSmallSize;
							text: 'LLM action in progress...').
			aMapElement addChildFirst: addedChild.
			addedChildren at: aDecoratorViewModel put: addedChild ]
]

{ #category : #accessing }
GtLlmWardleyMapInProgressDecorator >> initialize [
	super initialize.
	
	addedChildren := Dictionary new
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

{ #category : #accessing }
GtLlmWardleyMapInProgressDecorator >> undecorate: aMapElement decoratorViewModel: aDecoratorViewModel [
	BlTaskAction
		enqueueElement: aMapElement
		action: [ | addedChild |
			addedChild := BrHorizontalPane new fitContent
					padding: (BlInsets all: 5);
					addChild: BrGlamorousVectorIcons refresh asElement;
					addChild: (BrLabel new
							aptitude: BrGlamorousLabelAptitude new glamorousCodeFontAndSmallSize;
							text: 'LLM action in progress...').
			aMapElement addChildFirst: addedChild.
			addedChildren at: aDecoratorViewModel put: addedChild ]
]

{ #category : #accessing }
GtLlmWardleyMapInProgressDecorator >> undecorateMapElement: aMapElement decoratorViewModel: aDecoratorViewModel [
	BlTaskAction
		enqueueElement: aMapElement
		action: [ aMapElement removeChild: (addedChildren at: aDecoratorViewModel) ]
]
