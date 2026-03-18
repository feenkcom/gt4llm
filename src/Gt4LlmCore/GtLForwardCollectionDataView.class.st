Class {
	#name : #GtLForwardCollectionDataView,
	#superclass : #GtLForwardDataView,
	#category : #Gt4LlmCore
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
	
	[currentCollection := self targetCollection ]
		on: Error do: [ :anError |
			^ self errorViewWithException: anError isFrozen: false ]. 
	targetView := self compositeData.
	
	currentCollection do: [ :each |
		targetView addDataView: (self computeForwardedViewFor: [ each ]) ].

	^targetView
]

{ #category : #serialization }
GtLForwardCollectionDataView >> serializeToLlmPrimiteDataOn: aBuilder [
	self assert: [ self dataKey notNil ].
	
	self targetDataView isErrorView ifTrue: [
		^ self targetDataView serializeToLlmPrimiteDataOn: aBuilder  ].
	
	aBuilder 
		forDataKey: self dataKey
		do: [
			self targetDataView dataViews do: [ :each |
				each serializeToLlmPrimiteDataOn: aBuilder ] ]
]

{ #category : #accessing }
GtLForwardCollectionDataView >> targetCollection [
	^ self targetObject
]
