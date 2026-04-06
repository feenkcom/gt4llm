"
I provide common assertion methods for testing data views in examples.
"
Trait {
	#name : #TGtLDataViewAssertions,
	#category : #'Gt4LlmCore-Examples-Data Views'
}

{ #category : #'assertions - composite views' }
TGtLDataViewAssertions >> assertCompositeDataView: aDataView hasTitle: aTitle dataKey: aDataKey viewsCount: aCount [
	"Assert that the data view is a composite view with the expected title, data key and number of contained views"
	self assert: aDataView class equals: GtLCompositeDataView.
	self assert: aDataView title equals: aTitle.
	self assert: aDataView dataKey equals: aDataKey.
	self assert: aDataView dataViews size equals: aCount
]

{ #category : #'assertions - composite views' }
TGtLDataViewAssertions >> assertCompositeDataView: aDataView hasTitle: aTitle viewsCount: aCount [
	"Assert that the data view is a composite view with the expected title, nil data key and number of contained views"
	self assertCompositeDataView: aDataView hasTitle: aTitle dataKey: nil viewsCount: aCount
]

{ #category : #'assertions - composite views' }
TGtLDataViewAssertions >> assertCompositeView: aCompositeView hasEmptyDataViewWithDataKey: aDataKey [
	"Assert that there is an empty view in the given composite with the given dataKey."
	
	self assert: (aCompositeView dataViews  
		anySatisfy: [:aView |
			aView class = GtLEmptyDataView and: [
				aView dataKey = aDataKey]])
]

{ #category : #'assertions - composite views' }
TGtLDataViewAssertions >> assertCompositeView: aCompositeView hasInnerCompositeWithViewCount: anInteger [
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

{ #category : #'assertions - composite views' }
TGtLDataViewAssertions >> assertCompositeView: aCompositeView hasJsonDataViewWithDataKey: aDataKey [
	"Assert that there is a view in the given composite that is a json view with the given dataKey."
	
	self assert: (aCompositeView dataViews  
		anySatisfy: [:aView |
			aView class = GtLJsonDataView and: [
				aView dataKey = aDataKey]])
]

{ #category : #'assertions - composite views' }
TGtLDataViewAssertions >> assertCompositeView: aCompositeView hasJsonDataViewsWithDataKeys: anArray [
	"Assert that the composite view contains JSON data views with the given data keys."
	self assert: aCompositeView dataViews size equals: anArray size.
	
	aCompositeView dataViews do: [ :each |
		self assert: each class equals: GtLJsonDataView ]. 
	self 
		assert: (aCompositeView dataViews 
			collect: [ :each  | each dataKey ])  asSet
		equals: anArray asSet.
]

{ #category : #'assertions - composite views' }
TGtLDataViewAssertions >> assertCompositeView: aCompositeView hasMagritteDataViewWithDataKey: aDataKey [
	"Assert that there is a view in the given composite that is a magritte view with the given dataKey."
	
	self assert: (aCompositeView dataViews  
		anySatisfy: [:aView |
			aView class = GtLMagritteDataView and: [
				aView dataKey = aDataKey]])
]

{ #category : #'assertions - composite views' }
TGtLDataViewAssertions >> assertCompositeView: aCompositeView hasSingleJsonDataViewWithDataKey: aDataKey [
	"Assert that aCompositeView is a GtLCompositeDataView with exactly one GtLJsonDataView having the given dataKey."
	self assert: aCompositeView isNotNil.
	self assert: aCompositeView class equals: GtLCompositeDataView.
	self assert: aCompositeView dataViews size equals: 1.
	self assert: aCompositeView isWithArraySerialization not.
	self assert: aCompositeView dataViews first class equals: GtLJsonDataView.
	self assert: aCompositeView dataViews first dataKey equals: aDataKey
]

{ #category : #'assertions - composite views' }
TGtLDataViewAssertions >> assertCompositeView: aCompositeView hasSingleMagritteDataViewWithDataKey: aDataKey [
	"Assert that aCompositeView is a GtLCompositeDataView with exactly one GtLMagritteDataView having the given dataKey."
	self assert: aCompositeView isNotNil.
	self assert: aCompositeView class equals: GtLCompositeDataView.
	self assert: aCompositeView dataViews size equals: 1.
	self assert: aCompositeView dataViews first class equals: GtLMagritteDataView.
	self assert: aCompositeView dataViews first dataKey equals: aDataKey
]

{ #category : #'assertions - forward views' }
TGtLDataViewAssertions >> assertForwardDataView: aForwardDataView hasTargetObject: anObject [
	"Assert that aForwardDataView targets the expected object and uses the default view symbol."
	self assert: aForwardDataView class equals: GtLForwardObjectDataView.
	self assert: aForwardDataView targetObject equals: anObject.
	self assert: aForwardDataView viewSymbol equals: #llmDataViewsFor:
]

{ #category : #'assertions - forward views' }
TGtLDataViewAssertions >> assertForwardDataView: aForwardDataView hasTargetObject: anObject withDataKey: aDataKey [
	"Assert that aForwardDataView targets the expected object with the given data key."
	self assertForwardDataView: aForwardDataView hasTargetObject: anObject.
	self assert: aForwardDataView dataKey equals: aDataKey
]

{ #category : #'assertions - forward views' }
TGtLDataViewAssertions >> assertForwardObjectDataView: aDataView hasDataKey: aDataKey targetObject: anObject [
	"Assert that the data view is a forward object data view with the expected data key, target object and default view symbol"
	self assertForwardObjectDataView: aDataView hasDataKey: aDataKey targetObject: anObject viewSymbol: #llmDataViewsFor:
]

{ #category : #'assertions - forward views' }
TGtLDataViewAssertions >> assertForwardObjectDataView: aDataView hasDataKey: aDataKey targetObject: anObject viewSymbol: aSymbol [
	"Assert that the data view is a forward object data view with the expected data key, target object and view symbol"
	self assert: aDataView class equals: GtLForwardObjectDataView.
	self assert: aDataView dataKey equals: aDataKey.
	self assert: aDataView targetObject equals: anObject.
	self assert: aDataView viewSymbol equals: aSymbol
]

{ #category : #'assertions - forward views' }
TGtLDataViewAssertions >> assertForwardObjectDataView: aDataView hasTargetObject: anObject [
	"Assert that the data view is a forward object data view with no data key and the expected target object"
	self assertForwardObjectDataView: aDataView hasDataKey: nil targetObject: anObject
]
