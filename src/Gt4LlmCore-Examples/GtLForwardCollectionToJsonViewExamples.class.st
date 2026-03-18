Class {
	#name : #GtLForwardCollectionToJsonViewExamples,
	#superclass : #GtLForwardCollectionDataViewExamples,
	#category : 'Gt4LlmCore-Examples-Data Views'
}

{ #category : #examples }
GtLForwardCollectionToJsonViewExamples >> forwardToJsonViewWithoutDataKeys [
	<gtExample>
	| collection dataView |
	collection := self objectsWithJsonViews.
	
	dataView := GtLForwardCollectionDataView new
		collection: [ collection ];
		view: #gtLlmFirstJsonViewFor:.
	
	self assert: dataView targetCollection equals: collection.
	self assert: dataView dataKey isNil.
	"self 
		assertCompositeView: dataView targetDataView 
		hasSingleJsonDataViewWithDataKey: #firstData."
	
	^ dataView targetDataView
]

{ #category : #'examples - support' }
GtLForwardCollectionToJsonViewExamples >> objectsWithJsonViews [
	<gtExample>
	| objects |
	
	objects := (1 to: 3) collect:[  :each |
		| object |
		object := GtLObjectWithJsonViewsForExamples new.
		object firstValue: 10 * each.
		object secondValue: 11 * each.
	
		self assert: object firstJsonViewEnabled.
		self assert: object secondJsonViewEnabled.
		self assert: object firstJsonViewDataKey isNil.
		self assert: object secondJsonViewDataKey isNil.
	
		object ].
		
	^objects
]
