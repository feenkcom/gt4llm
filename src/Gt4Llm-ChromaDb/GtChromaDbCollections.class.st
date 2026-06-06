Class {
	#name : #GtChromaDbCollections,
	#superclass : #GtLGroup,
	#instVars : [
		'databaseName'
	],
	#category : #'Gt4Llm-ChromaDb-Model'
}

{ #category : #accessing }
GtChromaDbCollections >> databaseName [
	^ databaseName
]

{ #category : #accessing }
GtChromaDbCollections >> databaseName: anObject [
	databaseName := anObject
]

{ #category : #ui }
GtChromaDbCollections >> gtCollectionsFor: aView [
	<gtView>

	items ifNil: [ ^ aView empty ].
	^ aView columnedList
		title: 'Collections';
		priority: 10;
		items: [ items ];
		column: 'Collection' text: [ :item | item name ]
]
