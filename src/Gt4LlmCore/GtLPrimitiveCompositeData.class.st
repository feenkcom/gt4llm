Class {
	#name : #GtLPrimitiveCompositeData,
	#superclass : #GtLPrimitiveData,
	#instVars : [
		'items'
	],
	#category : #'Gt4LlmCore-Domain Objects'
}

{ #category : #'instance creation' }
GtLPrimitiveCompositeData class >> with: anObject [ 
	^ self new 
		add: anObject;
		yourself
]

{ #category : #adding }
GtLPrimitiveCompositeData >> add: aDataItem [
	items add: aDataItem
]

{ #category : #initialization }
GtLPrimitiveCompositeData >> initialize [
	super initialize.
	
	items := OrderedCollection new.
]

{ #category : #serialization }
GtLPrimitiveCompositeData >> serializeToOpenAIResponseOutput [
	<return: #NeoJSONArray>
	
	^ items 
			collect: [ :each |
				each serializeToOpenAIResponseOutput ]
			as: Array
]
