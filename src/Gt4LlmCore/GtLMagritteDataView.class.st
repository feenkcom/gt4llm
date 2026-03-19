Class {
	#name : #GtLMagritteDataView,
	#superclass : #GtLDataView,
	#instVars : [
		'objectComputation',
		'computedTargetObject',
		'cachedTargetDataView'
	],
	#category : #Gt4LlmCore
}

{ #category : #accessing }
GtLMagritteDataView >> computeTargetView [
	^ cachedTargetDataView := self jsonData
		data: [ 
			GtMagritteJSONDataExporter exportObject: self targetObject ];
		dataKey: self dataKey
]

{ #category : #'gt - extensions' }
GtLMagritteDataView >> gtPhlowTreeChildren [
	^ {cachedTargetDataView}
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
