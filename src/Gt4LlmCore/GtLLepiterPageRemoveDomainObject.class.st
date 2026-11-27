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
	#category : #'Gt4LlmCore-Magritte Objects'
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
		comment: 'The id of the database of the page.';
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

{ #category : #'llm views' }
GtLLepiterPageRemoveDomainObject >> llmRawDataViewFor: aDataView [
	<gtLlmDataView>
	
	^ aDataView magritteObject: [ self ]
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
GtLLepiterPageRemoveDomainObject >> pageTitle [
	^ title
]

{ #category : #'accessing - descriptions' }
GtLLepiterPageRemoveDomainObject >> pageTitleDescription [
	<magritteDescription>
	^ MAStringDescription new
		label: 'Page title';
		accessor: #pageTitle;
		comment: 'The title of the page.';
		beRequired
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
		comment: 'The id of the removed page (base 36).';
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
		comment: 'removed.';
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
