"
I am an abstract superclass for data view examples. I provide common utilities for testing data view serialization.
"
Class {
	#name : #GtLDataViewExamples,
	#superclass : #Object,
	#category : #'Gt4LlmCore-Examples-Data Views'
}

{ #category : #assertions }
GtLDataViewExamples >> assertCompositeView: aCompositeView hasInnerCompositeWithViewCount: anInteger [
	"Assert that aCompositeView is a composite containing another composite with the given number of views."
	| innerComposite |
	self assert: aCompositeView isNotNil.
	self assert: aCompositeView class equals: GtLCompositeDataView.
	self assert: aCompositeView dataViews size equals: 1.
	
	innerComposite := aCompositeView dataViews first.
	self assert: innerComposite class equals: GtLCompositeDataView.
	self assert: innerComposite dataViews size equals: anInteger.
	
	^ innerComposite
]

{ #category : #assertions }
GtLDataViewExamples >> assertCompositeView: aCompositeView hasJsonDataViewWithDataKey: aDataKey [
	"Assert that there is a view in the given composite that is a json view with the given dataKey."
	
	self assert: (aCompositeView dataViews  
		anySatisfy: [:aView |
			aView class = GtLJsonDataView and: [
				aView dataKey = aDataKey]])
]

{ #category : #assertions }
GtLDataViewExamples >> assertCompositeView: aCompositeView hasJsonDataViewsWithDataKeys: anArray [ 
	self assert: aCompositeView dataViews size equals: anArray size.
	
	aCompositeView dataViews  do: [ :each |
		self assert: each class equals: GtLJsonDataView ]. 
	self 
		assert: (aCompositeView dataViews 
			collect: [ :each  | each dataKey ])  asSet
		equals: anArray asSet.
]

{ #category : #assertions }
GtLDataViewExamples >> assertCompositeView: aCompositeView hasMagritteDataViewWithDataKey: aDataKey [
	"Assert that there is a view in the given composite that is a magritte view with the given dataKey."
	
	self assert: (aCompositeView dataViews  
		anySatisfy: [:aView |
			aView class = GtLMagritteDataView and: [
				aView dataKey = aDataKey]])
]

{ #category : #assertions }
GtLDataViewExamples >> assertCompositeView: aCompositeView hasSingleJsonDataViewWithDataKey: aDataKey [
	self assert: aCompositeView isNotNil.
	self assert: aCompositeView class equals: GtLCompositeDataView.
	self assert: aCompositeView dataViews size equals: 1.
	self assert: aCompositeView isWithArraySerialization not.
	self assert: aCompositeView dataViews first class equals: GtLJsonDataView.
	self assert: aCompositeView dataViews first dataKey equals: aDataKey
]

{ #category : #assertions }
GtLDataViewExamples >> assertCompositeView: aCompositeView hasSingleMagritteDataViewWithDataKey: aDataKey [
	"Assert that aCompositeView is a GtLCompositeDataView with exactly one GtLMagritteDataView having the given dataKey."
	self assert: aCompositeView isNotNil.
	self assert: aCompositeView class equals: GtLCompositeDataView.
	self assert: aCompositeView dataViews size equals: 1.
	self assert: aCompositeView dataViews first class equals: GtLMagritteDataView.
	self assert: aCompositeView dataViews first dataKey equals: aDataKey
]

{ #category : #assertions }
GtLDataViewExamples >> assertForwardDataView: aForwardDataView hasTargetObject: anObject [
	"Assert that aForwardDataView targets the expected object and uses the default view symbol."
	self assert: aForwardDataView class equals: GtLForwardObjectDataView.
	self assert: aForwardDataView targetObject equals: anObject.
	self assert: aForwardDataView viewSymbol equals: #llmDataViewsFor:
]

{ #category : #assertions }
GtLDataViewExamples >> assertForwardDataView: aForwardDataView hasTargetObject: anObject withDataKey: aDataKey [
	"Assert that aForwardDataView targets the expected object with the given data key."
	self assertForwardDataView: aForwardDataView hasTargetObject: anObject.
	self assert: aForwardDataView dataKey equals: aDataKey
]
