Class {
	#name : #GtLGrepFilesMatches,
	#superclass : #Object,
	#instVars : [
		'query',
		'files'
	],
	#category : #Gt4LlmCore
}

{ #category : #accessing }
GtLGrepFilesMatches >> files [
	^ files ifNil: [ #() ]
]

{ #category : #accessing }
GtLGrepFilesMatches >> files: aCollection [
	files := aCollection
]

{ #category : #magritte }
GtLGrepFilesMatches >> filesDescription [
	<magritteDescription>

	^ MAToManyRelationDescription new
		accessor: #files;
		classes: {GtLGrepFilePathReference. GtLMissingDomainObject. GtLProblemDomainObject};
		beRequired
]

{ #category : #gt }
GtLGrepFilesMatches >> gtFilesFor: aView [
	<gtView>
	<gtLlmView>
	^ aView columnedList
		title: 'Matches';
		priority: 1;
		items: [ self files ];
		column: 'File' text: [ :each | each pathString ];
		column: 'Matches' text: [ :each | each ranges size ]
]

{ #category : #accessing }
GtLGrepFilesMatches >> query [
	^ query
]

{ #category : #accessing }
GtLGrepFilesMatches >> query: aString [
	query := aString
]

{ #category : #magritte }
GtLGrepFilesMatches >> queryDescription [
	<magritteDescription>

	^ MAStringDescription new
		label: 'Query';
		accessor: #query;
		beRequired
]
