"
Holds class search results for LLM tools.
"
Class {
	#name : #GtLClassesSearchResult,
	#superclass : #Object,
	#instVars : [
		'foundClassNames',
		'mayHaveMore'
	],
	#category : #'Gt4LlmCore-Magritte Objects'
}

{ #category : #'instance creation' }
GtLClassesSearchResult class >> fromClasses: aCollection [
	| matchesArray limited |
	matchesArray := aCollection asArray.
	limited := matchesArray first: (200 min: matchesArray size).
	^ self new
		foundClassNames: (limited collect: [ :each | each name ]);
		mayHaveMore: matchesArray size > 200;
		yourself
]

{ #category : #accessing }
GtLClassesSearchResult >> foundClassNames [
	^ foundClassNames ifNil: [ #() ]
]

{ #category : #accessing }
GtLClassesSearchResult >> foundClassNames: aCollection [
	foundClassNames := aCollection
]

{ #category : #accessing }
GtLClassesSearchResult >> foundClassNamesDescription [
	<magritteDescription>

	^ MAToManyScalarRelationDescription new
		label: 'Found class names';
		accessor: #foundClassNames;
		classes: { String };
		beRequired
]

{ #category : #views }
GtLClassesSearchResult >> gtFoundClassNamesFor: aView [
	<gtView>
	<gtLlmView>
	self foundClassNames ifNil: [ ^ aView empty ].
	^ aView list
		title: 'Classes';
		priority: 1;
		items: [ self foundClassNames ];
		itemText: [ :each | each ]
]

{ #category : #accessing }
GtLClassesSearchResult >> mayHaveMore [
	^ mayHaveMore ifNil: [ false ]
]

{ #category : #accessing }
GtLClassesSearchResult >> mayHaveMore: aBoolean [
	mayHaveMore := aBoolean
]

{ #category : #accessing }
GtLClassesSearchResult >> mayHaveMoreDescription [
	<magritteDescription>

	^ MABooleanDescription new
		label: 'May have more';
		accessor: #mayHaveMore;
		beRequired
]

{ #category : #printing }
GtLClassesSearchResult >> printOn: aStream [
	super printOn: aStream.
	aStream parenthesize: [
		aStream
			nextPutAll: self foundClassNames size asString;
			nextPutAll: ' classes'.
		self mayHaveMore ifTrue: [ aStream nextPutAll: ' (more available)' ] ]
]
