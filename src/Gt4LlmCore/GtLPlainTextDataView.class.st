Class {
	#name : #GtLPlainTextDataView,
	#superclass : #GtLDataViewDecorator,
	#instVars : [
		'objectComputation',
		'computedTargetObject',
		'cachedTargetDataView'
	],
	#category : 'Gt4LlmCore-Data Views'
}

{ #category : #accessing }
GtLPlainTextDataView >> computeTargetView [
	^ cachedTargetDataView := self jsonData
			title: 'Plain Text';
			data: [ 
				GtMagritteJSONDataExporter exportObject: self targetObject ];
			dataKey: self dataKey
]

{ #category : #'gt - extensions' }
GtLPlainTextDataView >> gtPhlowTreeChildren [
	^ {cachedTargetDataView}
]

{ #category : #'gt - extensions' }
GtLPlainTextDataView >> gtViewContentJsonDataFor: aView [
	<gtView>
	<gtLlmMessageView>
	
	^(aView forward)
		title: 'JSON Data';
		priority: 30;
		object: [ self serializeToLlmPrimiteData  ];
		view: #gtViewCondensedJsonDataFor:
		
]

{ #category : #'gt - extensions' }
GtLPlainTextDataView >> gtViewContentJsonStringFor: aView [
	<gtView>
	<gtLlmMessageView>
	
	^(aView forward)
		title: 'JSON String';
		priority: 30.1;
		object: [ self serializeToLlmPrimiteData  ];
		view: #gtViewCondensedJsonStringFor:
		
]

{ #category : #accessing }
GtLPlainTextDataView >> object: aBlockClosure [
	objectComputation := aBlockClosure.
	computedTargetObject := nil.
	cachedTargetDataView := self jsonData: [
		GtMagritteJSONDataExporter exportObject: self targetObject ].
	cachedTargetDataView dataKey: self dataKey
]

{ #category : #serialization }
GtLPlainTextDataView >> serializeToLlmPrimiteDataOn: aBuilder [
	self computeTargetView serializeToLlmPrimiteDataOn: aBuilder 
]

{ #category : #accessing }
GtLPlainTextDataView >> targetObject [
	^computedTargetObject ifNil: [
		computedTargetObject := objectComputation value ]
]
