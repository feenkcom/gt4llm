Class {
	#name : #GtLGrepFilePathReference,
	#superclass : #GtLFilePathReference,
	#instVars : [
		'ranges'
	],
	#category : #'Gt4LlmCore-Magritte Objects'
}

{ #category : #accessing }
GtLGrepFilePathReference >> addRange: aRange [
	ranges ifNil: [ ranges := OrderedCollection new ].
	ranges add: aRange
]

{ #category : #gt }
GtLGrepFilePathReference >> gtFileContentsFor: aView [
	<gtView>
	(self asFileReference exists and: [ self asFileReference isFile ]) ifFalse: [ ^ aView empty ].
	^ aView textEditor
		title: 'Contents';
		priority: 1;
		aptitude: BrGlamorousCodeEditorAptitude;
		text: [ self rangedFileReference highlightedText ]
]

{ #category : #views }
GtLGrepFilePathReference >> gtRangesFor: aView [
	<gtView>
	ranges ifNil: [ ^ aView empty ].
	^ aView columnedList
		title: 'Ranges';
		priority: 2;
		items: [ ranges ];
		column: 'Value' text: [ :each | each matchString ];
		column: 'Start index' text: [ :each | each startIndex ];
		column: 'End index' text: [ :each | each endIndex ]
]

{ #category : #private }
GtLGrepFilePathReference >> rangedFileReference [
	| rangedReference |
	rangedReference := self asFileReference asGtFileReferenceWithRanges.
	self ranges do: [ :range |
		rangedReference
			addStartIndex: range startIndex
			endIndex: range endIndex ].
	^ rangedReference
]

{ #category : #accessing }
GtLGrepFilePathReference >> ranges [
	^ ranges ifNil: [ #() ]
]

{ #category : #accessing }
GtLGrepFilePathReference >> ranges: aCollection [
	ranges := aCollection
]

{ #category : #magritte }
GtLGrepFilePathReference >> rangesDescription [
	<magritteDescription>

	^ MAToManyRelationDescription new
		accessor: #ranges;
		classes: {GtLGrepMatchRange};
		yourself
]
