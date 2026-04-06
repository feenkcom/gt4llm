Class {
	#name : #GtLForwardCollectionDataView,
	#superclass : #GtLForwardDataView,
	#category : 'Gt4LlmCore-Data Views'
}

{ #category : #'api - scripting' }
GtLForwardCollectionDataView >> collection: aBlock [
	self object: aBlock
]

{ #category : #accessing }
GtLForwardCollectionDataView >> computeForwardedViews [
	^self targetCollection collect: [ :each |
		self computeForwardedViewFor: [ each ] ]
]

{ #category : #accessing }
GtLForwardCollectionDataView >> computeTargetView [
	| currentCollection targetView |
	
	[ currentCollection := self targetCollection ]
		on: Error do: [ :anError |
			^ self 
				errorViewWithException: anError 
				reason: 'Error computing target collection for collection forwarded data view' 
				isFrozen: false ]. 
			
	targetView := self compositeData.
	targetView beWithArraySerialization.
	
	currentCollection do: [ :each |
		targetView addDataView: (self computeForwardedViewFor: [ each ]) ].

	^targetView
]

{ #category : #serialization }
GtLForwardCollectionDataView >> serializeToLlmPrimiteDataOn: aBuilder [
	self targetDataView serializeToLlmPrimiteDataOn: aBuilder
]

{ #category : #accessing }
GtLForwardCollectionDataView >> targetCollection [
	^ self targetObject
]
