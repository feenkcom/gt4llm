Class {
	#name : #GtLGrepFilePathReference,
	#superclass : #GtLFilePathReference,
	#instVars : [
		'ranges'
	],
	#category : #Gt4LlmCore
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
		text: [ self rangedFileReference highlightedText ]
]

{ #category : #views }
GtLGrepFilePathReference >> gtRangesFor: aView [
	<gtView>
	ranges ifNil: [ ^ aView empty ].
	^ aView columnedList
		title: 'Ranges';
		items: [ ranges ];
		column: 'Value' text: [ :each | each gtDisplayString ]
]

{ #category : #private }
GtLGrepFilePathReference >> rangedFileReference [
	| rangedReference |
	rangedReference := self asFileReference asGtFileReferenceWithRanges.
	self ranges do: [ :range |
		rangedReference
			addStartLine: range startLine
			startColumn: range startColumn
			endLine: range endLine
			endColumn: range endColumn ].
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
