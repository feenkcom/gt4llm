Class {
	#name : #GtLLepiterPageCreateDomainObject,
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
GtLLepiterPageCreateDomainObject >> databaseId [
	^ databaseId
]

{ #category : #accessing }
GtLLepiterPageCreateDomainObject >> databaseId: aString [
	databaseId := aString
]

{ #category : #magritte }
GtLLepiterPageCreateDomainObject >> databaseIdDescription [
	<magritteDescription>

	^ MAStringDescription new
		label: 'Database id';
		accessor: #databaseId;
		beRequired
]

{ #category : #views }
GtLLepiterPageCreateDomainObject >> gtPageFor: aView [
	<gtView>
	<gtLlmView>
	^ aView forward
		title: 'Page';
		priority: 1;
		object: [ page ];
		view: #gtLiveFor:
]

{ #category : #accessing }
GtLLepiterPageCreateDomainObject >> page [
	^ page
]

{ #category : #accessing }
GtLLepiterPageCreateDomainObject >> page: aPage [
	page := aPage
]

{ #category : #accessing }
GtLLepiterPageCreateDomainObject >> pageUid [
	^ pageUid
]

{ #category : #accessing }
GtLLepiterPageCreateDomainObject >> pageUid: aString [
	pageUid := aString
]

{ #category : #magritte }
GtLLepiterPageCreateDomainObject >> pageUidDescription [
	<magritteDescription>

	^ MAStringDescription new
		label: 'Page uid';
		accessor: #pageUid;
		beRequired
]

{ #category : #accessing }
GtLLepiterPageCreateDomainObject >> status [
	^ status
]

{ #category : #accessing }
GtLLepiterPageCreateDomainObject >> status: aString [
	status := aString
]

{ #category : #magritte }
GtLLepiterPageCreateDomainObject >> statusDescription [
	<magritteDescription>

	^ MAStringDescription new
		label: 'Status';
		accessor: #status;
		beRequired
]

{ #category : #accessing }
GtLLepiterPageCreateDomainObject >> title [
	^ title
]

{ #category : #accessing }
GtLLepiterPageCreateDomainObject >> title: aString [
	title := aString
]

{ #category : #magritte }
GtLLepiterPageCreateDomainObject >> titleDescription [
	<magritteDescription>

	^ MAStringDescription new
		label: 'Title';
		accessor: #title;
		beRequired
]
