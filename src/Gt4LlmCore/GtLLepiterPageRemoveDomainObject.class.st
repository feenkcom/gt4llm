Class {
	#name : #GtLLepiterPageRemoveDomainObject,
	#superclass : #Object,
	#instVars : [
		'status',
		'pageUid',
		'title',
		'databaseId',
		'page'
	],
	#category : #Gt4LlmCore
}

{ #category : #accessing }
GtLLepiterPageRemoveDomainObject >> databaseId [
	^ databaseId
]

{ #category : #accessing }
GtLLepiterPageRemoveDomainObject >> databaseId: aString [
	databaseId := aString
]

{ #category : #magritte }
GtLLepiterPageRemoveDomainObject >> databaseIdDescription [
	<magritteDescription>

	^ MAStringDescription new
		label: 'Database id';
		accessor: #databaseId;
		beRequired
]

{ #category : #'gt-view' }
GtLLepiterPageRemoveDomainObject >> gtPageFor: aView [
	<gtView>
	<gtLlmView>
	^ aView forward
		title: 'Page';
		priority: 1;
		object: [ page ];
		view: #gtLiveFor:
]

{ #category : #accessing }
GtLLepiterPageRemoveDomainObject >> page [
	^ page
]

{ #category : #accessing }
GtLLepiterPageRemoveDomainObject >> page: aPage [
	page := aPage
]

{ #category : #accessing }
GtLLepiterPageRemoveDomainObject >> pageUid [
	^ pageUid
]

{ #category : #accessing }
GtLLepiterPageRemoveDomainObject >> pageUid: aString [
	pageUid := aString
]

{ #category : #magritte }
GtLLepiterPageRemoveDomainObject >> pageUidDescription [
	<magritteDescription>

	^ MAStringDescription new
		label: 'Page uid';
		accessor: #pageUid;
		beRequired
]

{ #category : #accessing }
GtLLepiterPageRemoveDomainObject >> status [
	^ status
]

{ #category : #accessing }
GtLLepiterPageRemoveDomainObject >> status: aString [
	status := aString
]

{ #category : #magritte }
GtLLepiterPageRemoveDomainObject >> statusDescription [
	<magritteDescription>

	^ MAStringDescription new
		label: 'Status';
		accessor: #status;
		beRequired
]

{ #category : #accessing }
GtLLepiterPageRemoveDomainObject >> title [
	^ title
]

{ #category : #accessing }
GtLLepiterPageRemoveDomainObject >> title: aString [
	title := aString
]

{ #category : #magritte }
GtLLepiterPageRemoveDomainObject >> titleDescription [
	<magritteDescription>

	^ MAStringDescription new
		label: 'Title';
		accessor: #title;
		beRequired
]
