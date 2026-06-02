Class {
	#name : #GtLNearestEmbeddingGroup,
	#superclass : #Object,
	#traits : 'TGtGroup',
	#classTraits : 'TGtGroup classTrait',
	#instVars : [
		'items'
	],
	#category : #'Gt4Llm-VectorDb-Support'
}

{ #category : #views }
GtLNearestEmbeddingGroup >> gtItemsFor: aView [
	<gtView>
	items ifNil: [ ^ aView empty ].
	^ aView columnedList
		title: 'Embeddings';
		items: [ items sorted: #distance ascending ];
		column: 'Distance' text: [ :each | each distance ];
		column: 'Title' text: [ :each | each embedding key gtDisplayString ]
]

{ #category : #accessing }
GtLNearestEmbeddingGroup >> items [
	^ items
]

{ #category : #accessing }
GtLNearestEmbeddingGroup >> items: anObject [
	items := anObject
]
