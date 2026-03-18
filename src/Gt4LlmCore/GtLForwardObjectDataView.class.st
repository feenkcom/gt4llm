Class {
	#name : #GtLForwardObjectDataView,
	#superclass : #GtLDataView,
	#instVars : [
		'objectComputation',
		'computedTargetObject',
		'viewSymbol',
		'computedTargetView'
	],
	#category : #Gt4LlmCore
}

{ #category : #accessing }
GtLForwardObjectDataView >> computeForwardedView [
	| targetObject computedView |
	
	[ targetObject := self targetObject ] 
		on: Error do: [ :anError |
			^ self errorViewWithException: anError isFrozen: false ].
	
	computedView := self on: targetObject perform: self viewSymbol.
	
	computedView class = self class ifTrue: [
		"If this forward is to another forward view we follow the chain
		to reach the first view that is now a forward view."
		^ computedView computeForwardedView ].
		
	^ computedView
]

{ #category : #'gt - extensions' }
GtLForwardObjectDataView >> gtPhlowTreeChildren [
	^ {self targetDataView}
]

{ #category : #'api - scripting' }
GtLForwardObjectDataView >> object: aBlockClosure [
	objectComputation := aBlockClosure.
	computedTargetObject := nil.
	computedTargetView := nil.
]

{ #category : #serialization }
GtLForwardObjectDataView >> serializeToLlmPrimiteDataOn: aBuilder [
	self targetDataView serializeToLlmPrimiteDataOn: aBuilder 
]

{ #category : #accessing }
GtLForwardObjectDataView >> targetDataView [
	^computedTargetView ifNil: [
		computedTargetView := self compositeData.
		computedTargetView addDataView: self computeForwardedView.
		dataKey ifNotNil: [ :aDataKey |
			computedTargetView dataKey: aDataKey ].
		computedTargetView ]
]

{ #category : #accessing }
GtLForwardObjectDataView >> targetObject [
	^computedTargetObject ifNil: [
		computedTargetObject := objectComputation value ]
]

{ #category : #'api - scripting' }
GtLForwardObjectDataView >> view: aSymbol [
	viewSymbol := aSymbol asSymbol
]

{ #category : #accessing }
GtLForwardObjectDataView >> viewSymbol [
	^viewSymbol ifNil: [ #llmDataViewsFor:	]
]
