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
GtLGrepFilesMatches >> gtMatchesFor: aView [
	<gtView>
	<gtLlmView>
	^ aView columnedList
		title: 'Matches';
		priority: 1;
		items: [ self files flatCollect: #ranges ];
		column: 'File' text: [ :each | each path ];
		column: 'Match' text: [ :each | each matchString ];
		column: 'Start line' text: [ :each | each startLine ] width: 100;
		column: 'Start column' text: [ :each | each startColumn ] width: 100
]

{ #category : #gt }
GtLGrepFilesMatches >> gtMatchesGroupedFor: aView [
	<gtView>
	<gtLlmView>
	^ aView columnedList
		title: 'Matches grouped';
		priority: 1;
		items: [ self files ];
		column: 'File' translated
			icon: [ :eachItem | 
				BrExpander new
					vFitContent;
					hMatchParent;
					collapse;
					margin: (BlInsets all: 10);
					aptitude: GtCoderExpanderAptitude new;
					header: [ BrLabel new
							aptitude: BrGlamorousLabelAptitude;
							text: eachItem pathString ];
					content: [ | container |
						container := BrFrame new
								vExact: 400;
								hMatchParent;
								aptitude: BrGlamorousWithVerticalResizerAptitude;
								addChild: ((eachItem gtFileContentsFor: GtPhlowEmptyView new) asElement constraintsDo: [:c | c vertical matchParent. c horizontal matchParent ]) ] ] weight: 1;
		column: 'Matches' text: [ :each | each ranges size ] width: 50
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
