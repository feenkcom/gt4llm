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
	^(aView columnedTree)
		title: 'Data Views';
		priority: 5;
		items: [dataViews];
		children: [ :each | each gtPhlowTreeChildren ];
		column: 'Value' text: [:each | each gtDisplayString]
]

{ #category : #'gt - extensions' }
GtLCompositeDataView >> gtPhlowTreeChildren [
	^ dataViews
]

{ #category : #initialization }
GtLCompositeDataView >> initialize [ 
	super initialize.
	dataViews := OrderedCollection new.
]

{ #category : #serialization }
GtLCompositeDataView >> serializeToLlmPrimiteDataOn: aBuilder [
	aBuilder 
		forDataKey: self dataKey
		do: [
			self dataViews do: [ :each |
				each serializeToLlmPrimiteDataOn: aBuilder ] ]
]

{ #category : #printing }
GtLCompositeDataView >> viewDescriptionOn: aStream [
	super viewDescriptionOn: aStream.
	
	aStream 
		<<'; '
		print: self dataViews size;
		<< ' ';
		<< (self dataViews size = 1 
			ifTrue: [ 'view' ]
			ifFalse: [ 'views' ])
]
