Class {
	#name : #GtLForwardCollectionDataViewExamples,
	#superclass : #GtLDataViewExamples,
	#category : #'Gt4LlmCore-Examples-Data Views'
}

{ #category : #'as yet unclassified' }
GtLForwardCollectionDataViewExamples >> assertArrayCompositeView: aCompositeView	hasSingleJsonDataViewsWithDataKeys: anArray [
	self assert: aCompositeView isNotNil.
	self assert: aCompositeView class equals: GtLCompositeDataView.
	self assert: aCompositeView isWithArraySerialization.
	self assert: aCompositeView dataViews size equals: anArray size.
	
	aCompositeView dataViews do: [ :each | 
		self assert: each class equals: GtLJsonDataView ].
	self 
		assert: (aCompositeView dataViews 
			collect: [ :each | each dataKey])  asArray
		equals: anArray asArray
]
