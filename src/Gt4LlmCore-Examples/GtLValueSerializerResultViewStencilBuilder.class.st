Class {
	#name : #GtLValueSerializerResultViewStencilBuilder,
	#superclass : #BrStencilBuilder,
	#instVars : [
		'originalView',
		'context',
		'object'
	],
	#category : 'Gt4LlmCore-Examples-Support'
}

{ #category : #'api - instantiation' }
GtLValueSerializerResultViewStencilBuilder >> buildDefault [
	<return: #BrStencil or: #BlElement>
	^ self object gtLiveFor: self originalView
]

{ #category : #accessing }
GtLValueSerializerResultViewStencilBuilder >> context [
	^ context ifNil: [ context := GtPhlowContext new ]
]

{ #category : #accessing }
GtLValueSerializerResultViewStencilBuilder >> context: anObject [
	context := anObject
]

{ #category : #accessing }
GtLValueSerializerResultViewStencilBuilder >> object [
	^ object
]

{ #category : #accessing }
GtLValueSerializerResultViewStencilBuilder >> object: anObject [
	object := anObject
]

{ #category : #accessing }
GtLValueSerializerResultViewStencilBuilder >> originalView [
	^ originalView ifNil: [ originalView := GtPhlowView empty ]
]

{ #category : #accessing }
GtLValueSerializerResultViewStencilBuilder >> originalView: anObject [
	originalView := anObject
]

{ #category : #'api - instantiation' }
GtLValueSerializerResultViewStencilBuilder >> paramsOn: aStencilExecutor [
	super paramsOn: aStencilExecutor.
	aStencilExecutor
		push: self object;
		push: self originalView;
		push: self context
]

{ #category : #initialization }
GtLValueSerializerResultViewStencilBuilder >> reset [
	super reset.
	object := nil.
	originalView := nil.
	context := nil
]
