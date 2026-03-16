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

{ #category : #'api - scripting' }
GtLMagritteDataView >> object: aBlockClosure [
	objectComputation := aBlockClosure.
	computedTargetObject := nil.
	targetDataView := self jsonData: [
		GtMagritteJSONDataExporter exportObject: self ]
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
