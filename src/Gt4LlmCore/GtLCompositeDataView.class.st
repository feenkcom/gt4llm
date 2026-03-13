Class {
	#name : #GtLCompositeDataView,
	#superclass : #GtLDataView,
	#instVars : [
		'dataViews'
	],
	#category : #Gt4LlmCore
}

{ #category : #adding }
GtLCompositeDataView >> addDataView: aDataView [
	dataViews add: aDataView
]

{ #category : #adding }
GtLCompositeDataView >> addDataViews: aCollection [
	aCollection do: [ :aView |
		self addDataView:  aView ]
]

{ #category : #accessing }
GtLCompositeDataView >> dataViews [
	^dataViews
]

{ #category : #views }
GtLCompositeDataView >> gtDataViewsFor: aView [
	<gtView>
	<gtLlmMessageView>
	dataViews ifNil: [^aView empty].
	^(aView columnedList)
		title: 'Data Views';
		priority: 5;
		items: [dataViews];
		column: 'Value' text: [:each | each gtDisplayString]
]

{ #category : #initialization }
GtLCompositeDataView >> initialize [ 
	super initialize.
	dataViews := OrderedCollection new.
]

{ #category : #accessing }
GtLCompositeDataView >> serializeToAnthropicResponseOutput [
	^self dataViews flatCollect: [:each |
		each serializeToAnthropicResponseOutput ] as: NeoJSONArray
]

{ #category : #accessing }
GtLCompositeDataView >> serializeToOpenAIResponseOutput [
	^self dataViews flatCollect: [:each |
		each serializeToOpenAIResponseOutput ] as: NeoJSONArray
]
