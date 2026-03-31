Class {
	#name : #GtLCompositeDataView,
	#superclass : #GtLDataView,
	#instVars : [
		'dataViews',
		'serializationType'
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

{ #category : #'api - configuration' }
GtLCompositeDataView >> beWithArraySerialization [
	serializationType := #array
]

{ #category : #accessing }
GtLCompositeDataView >> dataViews [
	^dataViews
]

{ #category : #'gt - extensions' }
GtLCompositeDataView >> gtDataViewsFor: aView [
	<gtView>
	<gtLlmMessageView>
	dataViews ifNil: [^aView empty].
	^(aView columnedTree)
		title: 'Data Views';
		priority: 20;
		items: [{self}];
		expandAll;
		children: [ :each | each gtPhlowTreeChildren ];
		column: 'Value' text: [:each | each gtDisplayString]
]

{ #category : #'gt - extensions' }
GtLCompositeDataView >> gtPhlowTreeChildren [
	^ dataViews
]

{ #category : #'gt - extensions' }
GtLCompositeDataView >> gtViewContentDataBlocksFor: aView [
	<gtView>
	
	dataViews ifNil: [^aView empty].
	^(aView forward)
		title: 'Data Blocks';
		priority: 20.1;
		object: [ self serializeToLlmPrimiteData  ];
		view: #gtViewDataBlocksFor:
		
]

{ #category : #'gt - extensions' }
GtLCompositeDataView >> gtViewContentJsonDataFor: aView [
	<gtView>
	
	dataViews ifNil: [^aView empty].
	^(aView forward)
		title: 'JSON Data';
		priority: 35.1;
		object: [ self serializeToLlmPrimiteData ];
		view: #gtViewCondensedJsonDataFor:
		
]

{ #category : #'gt - extensions' }
GtLCompositeDataView >> gtViewContentJsonStringFor: aView [
	<gtView>
	
	dataViews ifNil: [^aView empty].
	^(aView forward)
		title: 'JSON String';
		priority: 35.2;
		object: [ self serializeToLlmPrimiteData  ];
		view: #gtViewCondensedJsonStringFor:
		
]

{ #category : #initialization }
GtLCompositeDataView >> initialize [ 
	super initialize.
	dataViews := OrderedCollection new.
	serializationType := #object
]

{ #category : #testing }
GtLCompositeDataView >> isWithArraySerialization [
	^serializationType = #array
]

{ #category : #serialization }
GtLCompositeDataView >> serializeToLlmPrimiteDataOn: aBuilder [
	self isWithArraySerialization
		ifTrue: [
			aBuilder 
				forArrayWithDataKey: self dataKey
				do: [
					self dataViews do: [ :each |
						each serializeToLlmPrimiteDataOn: aBuilder ] ] ]
		ifFalse: [
			aBuilder 
				forDataKey: self dataKey
				do: [
					self dataViews do: [ :each |
						each serializeToLlmPrimiteDataOn: aBuilder ] ] ]
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
