Class {
	#name : #GtLLepiterPageReference,
	#superclass : #Object,
	#instVars : [
		'page',
		'pageId',
		'databaseId'
	],
	#category : #'Gt4LlmCore-Domain Objects'
}

{ #category : #accessing }
GtLLepiterPageReference >> databaseId [
	^ databaseId
]

{ #category : #accessing }
GtLLepiterPageReference >> databaseId: anObject [
	databaseId := anObject
]

{ #category : #accessing }
GtLLepiterPageReference >> databaseIdDescription [
	<magritteDescription>
	^ MAStringDescription new 
		label: 'DatabaseId';
		accessor: #databaseId
]

{ #category : #'gt-views' }
GtLLepiterPageReference >> gtPageFor: aView [
	<gtView>
	^ aView forward
		title: 'Page';
		priority: 10;
		object: [ page ];
		actionButtonIcon: BrGlamorousVectorIcons inspect
			tooltip: 'Inspect page'
			action: [ :aButton | aButton phlow spawnObject: page ];
		view: #gtLiveFor:
]

{ #category : #accessing }
GtLLepiterPageReference >> page [
	^ page
]

{ #category : #accessing }
GtLLepiterPageReference >> page: anObject [
	page := anObject.
	pageId := page uid asString36.
	databaseId := page database uuidString.
]

{ #category : #accessing }
GtLLepiterPageReference >> pageId [
	^ pageId
]

{ #category : #accessing }
GtLLepiterPageReference >> pageId: anObject [
	pageId := anObject
]

{ #category : #accessing }
GtLLepiterPageReference >> pageIdDescription [
	<magritteDescription>
	^ MAStringDescription new 
		label: 'PageId';
		accessor: #pageId
]

{ #category : #printing }
GtLLepiterPageReference >> printOn: aStream [
	aStream
		nextPutAll: 'pageId=';
		nextPutAll: pageId asString;
		nextPutAll: ', databaseId=';
		nextPutAll: databaseId asString
]
