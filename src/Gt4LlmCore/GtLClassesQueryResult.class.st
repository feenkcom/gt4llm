"
Holds class search results for LLM tools.
"
Class {
	#name : #GtLClassesQueryResult,
	#superclass : #Object,
	#instVars : [
		'query',
		'foundClassNames',
		'mayHaveMore'
	],
	#category : #Gt4LlmCore
}

{ #category : #accessing }
GtLClassesQueryResult >> foundClassNames [
	^ foundClassNames ifNil: [ #() ]
]

{ #category : #accessing }
GtLClassesQueryResult >> foundClassNames: aCollection [
	foundClassNames := aCollection
]

{ #category : #descriptions }
GtLClassesQueryResult >> foundClassNamesDescription [
	<magritteDescription>

	^ MAToManyScalarRelationDescription new
		label: 'Found class names';
		accessor: #foundClassNames;
		classes: {String};
		beRequired
]

{ #category : #views }
GtLClassesQueryResult >> gtFoundClassNamesFor: aView [
	<gtView>
	<gtLlmView>
	self foundClassNames ifNil: [ ^ aView empty ].
	^ aView list
		title: 'Classes';
		priority: 1;
		items: [ self foundClassNames ];
		itemText: [ :each | each ]
]

{ #category : #views }
GtLClassesQueryResult >> gtSummaryFor: aView [
	<gtView>
	^ aView text
		title: 'Summary';
		priority: 2;
		text: [ String streamContents: [ :stream |
			self query ifNotNil: [ :aQuery |
				stream
					nextPutAll: 'Query: ';
					nextPutAll: aQuery;
					nextPutAll: ' — ' ].
			stream
				nextPutAll: self foundClassNames size asString;
				nextPutAll: ' classes'.
			self mayHaveMore ifTrue: [ stream nextPutAll: ' (more available)' ] ] ]
]

{ #category : #accessing }
GtLClassesQueryResult >> mayHaveMore [
	^ mayHaveMore ifNil: [ false ]
]

{ #category : #accessing }
GtLClassesQueryResult >> mayHaveMore: aBoolean [
	mayHaveMore := aBoolean
]

{ #category : #descriptions }
GtLClassesQueryResult >> mayHaveMoreDescription [
	<magritteDescription>

	^ MABooleanDescription new
		label: 'May have more';
		accessor: #mayHaveMore;
		beRequired
]

{ #category : #printing }
GtLClassesQueryResult >> printOn: aStream [
	super printOn: aStream.
	aStream
		parenthesize: [ aStream
				nextPutAll: self foundClassNames size asString;
				nextPutAll: ' classes'.
			self mayHaveMore ifTrue: [ aStream nextPutAll: ' (more available)' ] ]
]

{ #category : #accessing }
GtLClassesQueryResult >> query [
	^ query
]

{ #category : #accessing }
GtLClassesQueryResult >> query: aString [
	query := aString
]

{ #category : #descriptions }
GtLClassesQueryResult >> queryDescription [
	<magritteDescription>

	^ MAStringDescription new
		label: 'Query';
		accessor: #query;
		beRequired
]
