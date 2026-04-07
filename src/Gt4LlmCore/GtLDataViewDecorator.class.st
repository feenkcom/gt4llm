Class {
	#name : #GtLDataViewDecorator,
	#superclass : #GtLDataView,
	#instVars : [
		'originalView'
	],
	#category : #'Gt4LlmCore-Data Views'
}

{ #category : #testing }
GtLDataViewDecorator class >> isAbstract [
	^ self name = #GtLDataViewDecorator 
]

{ #category : #accessing }
GtLDataViewDecorator >> allParentDecoratorsDo: aBlock [
	self originalView ifNotNil: [ 
		aBlock value: self originalView.
		self originalView allParentDecoratorsDo: aBlock ]
]

{ #category : #accessing }
GtLDataViewDecorator >> decoratorsChain [
	| decorators |
	decorators := OrderedCollection with: self.
	self allParentDecoratorsDo: [ :aDecorator |
			decorators add: aDecorator ].
	^ decorators
]

{ #category : #'message performing' }
GtLDataViewDecorator >> ensureContext [

	(self buildContext notNil and: [ 
		 self buildContext hasContext ]) ifTrue: [ 
		^ self buildContext context ].

	self originalView ifNil: [ ^ GtPhlowContext new ].

	(self originalView buildContext notNil and: [ 
		 self originalView buildContext hasContext ]) ifTrue: [ 
		^ self originalView buildContext context ].

	^ GtPhlowContext new
]

{ #category : #'gt extensions' }
GtLDataViewDecorator >> gtDecoratorChainFor: aView [
	<gtView>
	^ aView list 
		title: 'Decorators' translated;
		priority: 70;
		items: [ self decoratorsChain ]
]

{ #category : #accessing }
GtLDataViewDecorator >> originalView [
	^ originalView
]

{ #category : #accessing }
GtLDataViewDecorator >> originalView: aView [
	originalView := aView
]
