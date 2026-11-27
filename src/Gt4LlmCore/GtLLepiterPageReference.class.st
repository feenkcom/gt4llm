Class {
	#name : #GtLLepiterPageReference,
	#superclass : #Object,
	#instVars : [
		'page',
		'pageUid',
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
		label: 'Database id';
		accessor: #databaseId;
		comment: 'The id of the database of the page.';
		yourself
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
GtLLepiterPageReference >> page: aPage [
	page := aPage.
	pageUid := aPage uid asString36.
	databaseId := GtLLepiterSnippetReference databaseIdOf: aPage database
]

{ #category : #accessing }
GtLLepiterPageReference >> pageUid [
	^ pageUid
]

{ #category : #accessing }
GtLLepiterPageReference >> pageUid: aString [
	pageUid := aString
]

{ #category : #magritte }
GtLLepiterPageReference >> pageUidDescription [
	<magritteDescription>
	^ MAStringDescription new
		label: 'Page uid';
		accessor: #pageUid;
		comment: 'The id of the page (base 36).';
		yourself
]

{ #category : #printing }
GtLLepiterPageReference >> printOn: aStream [
	aStream
		nextPutAll: 'pageUid=';
		nextPutAll: pageUid asString;
		nextPutAll: ', databaseId=';
		nextPutAll: databaseId asString
]
