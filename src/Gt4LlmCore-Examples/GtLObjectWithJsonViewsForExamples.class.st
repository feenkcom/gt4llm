"
I am an example object with two JSON views for testing GtLForwardDataView. Views can be enabled/disabled and their data keys configured.
"
Class {
	#name : #GtLObjectWithJsonViewsForExamples,
	#superclass : #GtLObjectWithViewsForExamples,
	#instVars : [
		'firstJsonViewEnabled',
		'secondJsonViewEnabled',
		'firstJsonViewDataKey',
		'secondJsonViewDataKey'
	],
	#category : #'Gt4LlmCore-Examples-Data Views'
}

{ #category : #accessing }
GtLObjectWithJsonViewsForExamples >> firstJsonViewDataKey [
	^ firstJsonViewDataKey
]

{ #category : #accessing }
GtLObjectWithJsonViewsForExamples >> firstJsonViewDataKey: aSymbolOrNil [
	firstJsonViewDataKey := aSymbolOrNil
]

{ #category : #accessing }
GtLObjectWithJsonViewsForExamples >> firstJsonViewEnabled [
	^ firstJsonViewEnabled
]

{ #category : #accessing }
GtLObjectWithJsonViewsForExamples >> firstJsonViewEnabled: aBoolean [
	firstJsonViewEnabled := aBoolean
]

{ #category : #views }
GtLObjectWithJsonViewsForExamples >> gtLlmFirstJsonViewFor: aDataView [
	<gtLlmDataView>
	self firstJsonViewEnabled ifFalse: [ ^ aDataView emptyData ].
	
	^ aDataView jsonData
		data: [ 
			NeoJSONObject new
				at: 'type' put: 'first';
				at: 'value' put: 100;
				yourself ];
		dataKey: self firstJsonViewDataKey
]

{ #category : #views }
GtLObjectWithJsonViewsForExamples >> gtLlmSecondJsonViewFor: aDataView [
	<gtLlmDataView>
	self secondJsonViewEnabled ifFalse: [ ^ aDataView emptyData ].
	
	^ aDataView jsonData
		data: [ 
			NeoJSONObject new
				at: 'type' put: 'second';
				at: 'value' put: 200;
				yourself ];
		dataKey: self secondJsonViewDataKey
]

{ #category : #initialization }
GtLObjectWithJsonViewsForExamples >> initialize [
	super initialize.
	
	firstJsonViewEnabled := true.
	secondJsonViewEnabled := true.
	firstJsonViewDataKey := nil.
	secondJsonViewDataKey := nil
]

{ #category : #accessing }
GtLObjectWithJsonViewsForExamples >> secondJsonViewDataKey [
	^ secondJsonViewDataKey
]

{ #category : #accessing }
GtLObjectWithJsonViewsForExamples >> secondJsonViewDataKey: aSymbolOrNil [
	secondJsonViewDataKey := aSymbolOrNil
]

{ #category : #accessing }
GtLObjectWithJsonViewsForExamples >> secondJsonViewEnabled [
	^ secondJsonViewEnabled
]

{ #category : #accessing }
GtLObjectWithJsonViewsForExamples >> secondJsonViewEnabled: aBoolean [
	secondJsonViewEnabled := aBoolean
]
