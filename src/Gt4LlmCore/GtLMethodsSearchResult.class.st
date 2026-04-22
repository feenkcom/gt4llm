"
Holds method reference results for LLM tools.
"
Class {
	#name : #GtLMethodsSearchResult,
	#superclass : #Object,
	#instVars : [
		'foundMethods',
		'mayHaveMore'
	],
	#category : 'Gt4LlmCore-Magritte Objects'
}

{ #category : #'instance creation' }
GtLMethodsSearchResult class >> fromReferences: aCollection [
	| matchesArray limited |
	matchesArray := aCollection asArray.
	limited := matchesArray first: (200 min: matchesArray size).
	^ self new
		foundMethods: (limited collect: [ :each | GtLMethodReference fromCompiledMethod: each ]);
		mayHaveMore: matchesArray size > 200;
		yourself
]

{ #category : #accessing }
GtLMethodsSearchResult >> foundMethods [
	^ foundMethods ifNil: [ #() ]
]

{ #category : #accessing }
GtLMethodsSearchResult >> foundMethods: aCollection [
	foundMethods := aCollection
]

{ #category : #accessing }
GtLMethodsSearchResult >> foundMethodsDescription [
	<magritteDescription>

	^ MAToManyRelationDescription new
		label: 'Found methods';
		accessor: #foundMethods;
		classes: { GtLMethodReference };
		beRequired
]

{ #category : #views }
GtLMethodsSearchResult >> gtFoundMethodsFor: aView [
	<gtView>
	<gtLlmView>
	^ aView columnedList
		title: 'Found methods';
		priority: 1;
		items: [ self foundMethods ];
		column: 'Class' text: [ :each | each methodClass name ] width: 200;
		column: 'Method' text: [ :each | each methodName ]
]

{ #category : #'llm views' }
GtLMethodsSearchResult >> llmRawDataViewFor: aDataView [
	<gtLlmDataView>
	
	^ aDataView magritteObject: [ self ]
]

{ #category : #accessing }
GtLMethodsSearchResult >> mayHaveMore [
	^ mayHaveMore ifNil: [ false ]
]

{ #category : #accessing }
GtLMethodsSearchResult >> mayHaveMore: aBoolean [
	mayHaveMore := aBoolean
]

{ #category : #accessing }
GtLMethodsSearchResult >> mayHaveMoreDescription [
	<magritteDescription>

	^ MABooleanDescription new
		label: 'May have more';
		accessor: #mayHaveMore;
		beRequired
]

{ #category : #printing }
GtLMethodsSearchResult >> printOn: aStream [
	super printOn: aStream.
	aStream parenthesize: [
		aStream
			nextPutAll: self foundMethods size asString;
			nextPutAll: ' methods'.
		self mayHaveMore ifTrue: [ aStream nextPutAll: ' (more available)' ] ]
]
