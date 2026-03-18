"
I am an example object that has multiple types of LLM data views: JSON, Magritte, image, forward, and composite views. I am used to test forwarding to all views of an object.
"
Class {
	#name : #GtLObjectWithMultipleViewsForExamples,
	#superclass : #GtLObjectWithViewsForExamples,
	#instVars : [
		'name',
		'amount',
		'jsonViewDataKey',
		'magritteViewDataKey',
		'imageViewDataKey',
		'forwardViewDataKey',
		'compositeViewDataKey'
	],
	#category : 'Gt4LlmCore-Examples-Data Views'
}

{ #category : #accessing }
GtLObjectWithMultipleViewsForExamples >> amount [
	^ amount
]

{ #category : #accessing }
GtLObjectWithMultipleViewsForExamples >> amount: anInteger [
	amount := anInteger
]

{ #category : #magritte }
GtLObjectWithMultipleViewsForExamples >> amountDescription [
	<magritteDescription>
	^ MANumberDescription new
		accessor: #amount;
		label: 'Amount';
		priority: 2
]

{ #category : #views }
GtLObjectWithMultipleViewsForExamples >> gtLlmJsonViewFor: aDataView [
	<gtLlmView>
	<gtLlmDataView>
	^ aDataView jsonData
		data: [ 
			NeoJSONObject new
				at: 'itemName' put: self name;
				at: 'itemAmount' put: self amount;
				yourself ];
		dataKey: self jsonViewDataKey
]

{ #category : #views }
GtLObjectWithMultipleViewsForExamples >> gtLlmMagritteViewFor: aDataView [
	<gtLlmView>
	<gtLlmDataView>
	^ aDataView magritteObject
		object: [ self ];
		dataKey: self magritteViewDataKey
]

{ #category : #initialization }
GtLObjectWithMultipleViewsForExamples >> initialize [
	super initialize.
	name := 'Multi-View Item'.
	amount := 99
]

{ #category : #accessing }
GtLObjectWithMultipleViewsForExamples >> jsonViewDataKey [
	^ jsonViewDataKey
]

{ #category : #accessing }
GtLObjectWithMultipleViewsForExamples >> jsonViewDataKey: aSymbol [
	jsonViewDataKey := aSymbol
]

{ #category : #accessing }
GtLObjectWithMultipleViewsForExamples >> magritteViewDataKey [
	^ magritteViewDataKey
]

{ #category : #accessing }
GtLObjectWithMultipleViewsForExamples >> magritteViewDataKey: aSymbol [
	magritteViewDataKey := aSymbol
]

{ #category : #accessing }
GtLObjectWithMultipleViewsForExamples >> name [
	^ name
]

{ #category : #accessing }
GtLObjectWithMultipleViewsForExamples >> name: aString [
	name := aString
]

{ #category : #magritte }
GtLObjectWithMultipleViewsForExamples >> nameDescription [
	<magritteDescription>
	^ MAStringDescription new
		accessor: #name;
		label: 'Name';
		priority: 1
]
