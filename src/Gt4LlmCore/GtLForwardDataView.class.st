Class {
	#name : #GtLForwardDataView,
	#superclass : #GtLDataView,
	#instVars : [
		'objectComputation',
		'computedTargetObject',
		'computedDataView'
	],
	#category : #Gt4LlmCore
}

{ #category : #'gt - extensions' }
GtLForwardDataView >> gtPhlowTreeChildren [
	^ {self targetDataView}
]

{ #category : #'api - scripting' }
GtLForwardDataView >> object: aBlockClosure [
	objectComputation := aBlockClosure.
	computedTargetObject := nil.
	computedDataView := nil.
]

{ #category : #serialization }
GtLForwardDataView >> serializeToLlmPrimiteDataOn: aBuilder [
	self targetDataView serializeToLlmPrimiteDataOn: aBuilder 
]

{ #category : #accessing }
GtLForwardDataView >> targetDataView [
	^computedDataView ifNil: [
		computedDataView := self targetObject 
			llmDataViewsFor: GtLDataView empty.
		dataKey ifNotNil: [ :aDataKey |
			computedDataView dataKey: aDataKey ].
		computedDataView ]
]

{ #category : #accessing }
GtLForwardDataView >> targetObject [
	^computedTargetObject ifNil: [
		computedTargetObject := objectComputation value ]
]
