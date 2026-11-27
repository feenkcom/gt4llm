Class {
	#name : #GtLLepiterKnowledgeBase,
	#superclass : #Object,
	#instVars : [
		'databaseName',
		'databaseId',
		'pageCount',
		'storeLocation'
	],
	#category : #'Gt4LlmCore-Magritte Objects'
}

{ #category : #'instance creation' }
GtLLepiterKnowledgeBase class >> forDatabase: aDatabase [
	^ self new
		databaseName: aDatabase databaseName;
		databaseId: (GtLLepiterSnippetReference databaseIdOf: aDatabase);
		pageCount: aDatabase pageCount;
		storeLocation: aDatabase storeLocation asString;
		yourself
]

{ #category : #accessing }
GtLLepiterKnowledgeBase >> databaseId [
	^ databaseId
]

{ #category : #accessing }
GtLLepiterKnowledgeBase >> databaseId: aString [
	databaseId := aString
]

{ #category : #magritte }
GtLLepiterKnowledgeBase >> databaseIdDescription [
	<magritteDescription>
	^ MAStringDescription new
		label: 'Database id';
		accessor: #databaseId;
		comment: 'The id of the database, as the other Lepiter tools take it.';
		beRequired
]

{ #category : #accessing }
GtLLepiterKnowledgeBase >> databaseName [
	^ databaseName
]

{ #category : #accessing }
GtLLepiterKnowledgeBase >> databaseName: aString [
	databaseName := aString
]

{ #category : #magritte }
GtLLepiterKnowledgeBase >> databaseNameDescription [
	<magritteDescription>
	^ MAStringDescription new
		label: 'Database name';
		accessor: #databaseName;
		comment: 'The name of the database.';
		beRequired
]

{ #category : #printing }
GtLLepiterKnowledgeBase >> gtDisplayOn: aStream [
	aStream nextPutAll: (self databaseName ifNil: [ 'Unnamed' ])
]

{ #category : #'llm views' }
GtLLepiterKnowledgeBase >> llmRawDataViewFor: aDataView [
	<gtLlmDataView>
	
	^ aDataView magritteObject: [ self ]
]

{ #category : #accessing }
GtLLepiterKnowledgeBase >> pageCount [
	^ pageCount
]

{ #category : #accessing }
GtLLepiterKnowledgeBase >> pageCount: aNumber [
	pageCount := aNumber
]

{ #category : #magritte }
GtLLepiterKnowledgeBase >> pageCountDescription [
	<magritteDescription>
	^ MANumberDescription new
		label: 'Pages';
		accessor: #pageCount;
		comment: 'The number of pages in the database.';
		beRequired
]

{ #category : #accessing }
GtLLepiterKnowledgeBase >> storeLocation [
	^ storeLocation
]

{ #category : #accessing }
GtLLepiterKnowledgeBase >> storeLocation: aString [
	storeLocation := aString
]

{ #category : #magritte }
GtLLepiterKnowledgeBase >> storeLocationDescription [
	<magritteDescription>
	^ MAStringDescription new
		label: 'Store location';
		accessor: #storeLocation;
		comment: 'Where the database is stored.';
		beRequired
]
