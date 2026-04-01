Class {
	#name : #GtLLepiterKnowledgeBase,
	#superclass : #Object,
	#instVars : [
		'databaseName',
		'uuidString',
		'pageCount',
		'storeLocation'
	],
	#category : 'Gt4LlmCore-Magritte Objects'
}

{ #category : #'instance creation' }
GtLLepiterKnowledgeBase class >> forDatabase: aDatabase [ 
	^ self new 
			databaseName: aDatabase databaseName;
			uuidString: aDatabase uuidString;
			pageCount: aDatabase pageCount;
			storeLocation: aDatabase storeLocation asString;
			yourself
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
		beRequired
]

{ #category : #accessing }
GtLLepiterKnowledgeBase >> uuidString [
	^ uuidString
]

{ #category : #accessing }
GtLLepiterKnowledgeBase >> uuidString: aString [
	uuidString := aString
]

{ #category : #magritte }
GtLLepiterKnowledgeBase >> uuidStringDescription [
	<magritteDescription>
	^ MAStringDescription new
		label: 'UUID';
		accessor: #uuidString;
		beRequired
]
