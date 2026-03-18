Class {
	#name : #GtLMagritteDataView,
	#superclass : #GtLDataView,
	#instVars : [
		'objectComputation',
		'targetDataView',
		'computedTargetObject'
	],
	#category : #Gt4LlmCore
}

{ #category : #'gt - extensions' }
GtLMagritteDataView >> gtPhlowTreeChildren [
	^ {targetDataView}
]

{ #category : #accessing }
GtLMagritteDataView >> object: aBlockClosure [
	objectComputation := aBlockClosure.
	computedTargetObject := nil.
	targetDataView := self jsonData: [
		GtMagritteJSONDataExporter exportObject: self targetObject ].
	targetDataView dataKey: self dataKey
]

{ #category : #serialization }
GtLMagritteDataView >> serializeToLlmPrimiteDataOn: aBuilder [
	targetDataView serializeToLlmPrimiteDataOn: aBuilder 
]

{ #category : #accessing }
GtLMagritteDataView >> targetObject [
	^computedTargetObject ifNil: [
		computedTargetObject := objectComputation value ]
]
