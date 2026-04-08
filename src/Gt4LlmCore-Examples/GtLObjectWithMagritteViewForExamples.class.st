"
I am an example object with a Magritte description and view for testing GtLForwardDataView. The view data key can be configured.
"
Class {
	#name : #GtLObjectWithMagritteViewForExamples,
	#superclass : #GtLObjectWithViewsForExamples,
	#instVars : [
		'name',
		'amount',
		'magritteViewDataKey'
	],
	#category : #'Gt4LlmCore-Examples-Data Views'
}

{ #category : #accessing }
GtLObjectWithMagritteViewForExamples >> amount [
	^ amount
]

{ #category : #accessing }
GtLObjectWithMagritteViewForExamples >> amount: anInteger [
	amount := anInteger
]

{ #category : #magritte }
GtLObjectWithMagritteViewForExamples >> amountDescription [
	<magritteDescription>
	^ MANumberDescription new
		accessor: #amount;
		label: 'Amount';
		priority: 2;
		yourself
]

{ #category : #views }
GtLObjectWithMagritteViewForExamples >> gtLlmMagritteViewFor: aDataView [
	<gtLlmDataView>
	^ aDataView magritteObject
			object: [ self ];
			dataKey: self magritteViewDataKey
]

{ #category : #initialization }
GtLObjectWithMagritteViewForExamples >> initialize [
	super initialize.
	name := 'Example Item'.
	amount := 42.
	magritteViewDataKey := nil
]

{ #category : #accessing }
GtLObjectWithMagritteViewForExamples >> magritteViewDataKey [
	^ magritteViewDataKey
]

{ #category : #accessing }
GtLObjectWithMagritteViewForExamples >> magritteViewDataKey: aSymbolOrNil [
	magritteViewDataKey := aSymbolOrNil
]

{ #category : #accessing }
GtLObjectWithMagritteViewForExamples >> name [
	^ name
]

{ #category : #accessing }
GtLObjectWithMagritteViewForExamples >> name: aString [
	name := aString
]

{ #category : #magritte }
GtLObjectWithMagritteViewForExamples >> nameDescription [
	<magritteDescription>
	^ MAStringDescription new
		accessor: #name;
		label: 'Name';
		priority: 1;
		yourself
]
