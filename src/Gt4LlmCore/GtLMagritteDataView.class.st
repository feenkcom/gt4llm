Class {
	#name : #GtLMagritteDataView,
	#superclass : #GtLDataViewDecorator,
	#instVars : [
		'objectComputation',
		'computedTargetObject',
		'cachedTargetDataView'
	],
	#category : #'Gt4LlmCore-Data Views'
}

{ #category : #accessing }
GtLMagritteDataView >> computeTargetView [
	^ cachedTargetDataView := self jsonData
			title: 'Magritte JSON data';
			data: [ 
				GtMagritteJSONDataExporter exportObject: self targetObject ];
			dataKey: self dataKey
]

{ #category : #'gt - extensions' }
GtLMagritteDataView >> gtPhlowTreeChildren [
	^ {cachedTargetDataView}
]

{ #category : #'gt - extensions' }
GtLMagritteDataView >> gtViewContentJsonDataFor: aView [
	<gtView>
	<gtLlmMessageView>
	
	^(aView forward)
		title: 'JSON Data';
		priority: 30;
		object: [ self serializeToLlmPrimiteData  ];
		view: #gtViewCondensedJsonDataFor:
		
]

{ #category : #'gt - extensions' }
GtLMagritteDataView >> gtViewContentJsonStringFor: aView [
	<gtView>
	<gtLlmMessageView>
	
	^(aView forward)
		title: 'JSON String';
		priority: 30.1;
		object: [ self serializeToLlmPrimiteData  ];
		view: #gtViewCondensedJsonStringFor:
		
]

{ #category : #accessing }
GtLMagritteDataView >> object: aBlockClosure [
	objectComputation := aBlockClosure.
	computedTargetObject := nil.
	cachedTargetDataView := self jsonData: [
		GtMagritteJSONDataExporter exportObject: self targetObject ].
	cachedTargetDataView dataKey: self dataKey
]

{ #category : #serialization }
GtLMagritteDataView >> serializeToLlmPrimiteDataOn: aBuilder [
	self computeTargetView serializeToLlmPrimiteDataOn: aBuilder 
]

{ #category : #accessing }
GtLMagritteDataView >> targetObject [
	^computedTargetObject ifNil: [
		computedTargetObject := objectComputation value ]
]
