Class {
	#name : #GtLForwardObjectDataView,
	#superclass : #GtLForwardDataView,
	#category : #'Gt4LlmCore-Data Views'
}

{ #category : #accessing }
GtLForwardObjectDataView >> computeForwardedView [
	^self computeForwardedViewFor: [ self targetObject ]
]

{ #category : #accessing }
GtLForwardObjectDataView >> computeTargetView [
	| targetView |
	targetView := self compositeData.
	targetView title: 'Forwarded views'.
	targetView addDataView: self computeForwardedView.
	^targetView
]

{ #category : #accessing }
GtLForwardObjectDataView >> definingMethod: aMethod [
	definingMethodProvider := GtPhlowForwardViewDefiningMethodProvider new
		phlowForwardView: self;
		definingMethod: aMethod
]

{ #category : #accessing }
GtLForwardObjectDataView >> originMethodsInto: aStream [
	super originMethodsInto: aStream.

	self computeTargetView
		ifNotNil: [ :aPhlowView | 
			aPhlowView dataViews do: [ :each | each originMethodsInto: aStream ] ]
]
