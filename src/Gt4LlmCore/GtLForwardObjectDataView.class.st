Class {
	#name : #GtLForwardObjectDataView,
	#superclass : #GtLForwardDataView,
	#category : #Gt4LlmCore
}

{ #category : #accessing }
GtLForwardObjectDataView >> computeForwardedView [
	^self computeForwardedViewFor: [ self targetObject ]
]

{ #category : #accessing }
GtLForwardObjectDataView >> computeTargetView [
	| targetView |
	targetView := self compositeData.
	targetView addDataView: self computeForwardedView.
	^targetView
]
