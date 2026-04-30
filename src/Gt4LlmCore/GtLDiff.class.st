"
Models a composite diff containing multiple string diffs and can describe itself through Magritte.
"
Class {
	#name : #GtLDiff,
	#superclass : #Object,
	#instVars : [
		'diffs'
	],
	#category : 'Gt4LlmCore-Formats'
}

{ #category : #'instance creation' }
GtLDiff class >> withAll: aCollection [
	^ self new
		diffs: aCollection;
		yourself
]

{ #category : #accessing }
GtLDiff >> diffs [
	^ diffs ifNil: [ diffs := #() ]
]

{ #category : #accessing }
GtLDiff >> diffs: aCollection [
	diffs := aCollection
]

{ #category : #magritte }
GtLDiff >> diffsDescription [
	<magritteDescription>

	^ MAToManyRelationDescription new
		label: 'Diffs';
		accessor: #diffs;
		classes: { GtLStringDiff };
		beRequired
]

{ #category : #'gt-views' }
GtLDiff >> gtDiffsFor: aView [
	<gtView>
	<gtLlmView>
	^ aView columnedList
		title: 'Diffs';
		priority: 2;
		items: [ self diffs ];
		column: 'From' text: [ :each | each fromString ];
		column: 'To' text: [ :each | each toString ]
]

{ #category : #'gt-views' }
GtLDiff >> gtVisualDiffsFor: aView [
	<gtView>
	<gtLlmView>
	^ aView list
		title: 'Visual diffs';
		priority: 1;
		items: [ self diffs ];
		itemStencil: [
			GtMultiSplitterDiffElement new
				matchParent;
				fromLabel: 'Left';
				toLabel: 'Right';
				from: '';
				to: '';
				splitters: { GtCharacterGroupDiffSplitter words ignoreWhitespace } ];
		itemDataBinder: [ :anElement :aDiff :anIndex |
			anElement
				from: aDiff fromString;
				to: aDiff toString;
				onSelectedItemChanged ]
]

{ #category : #printing }
GtLDiff >> printOn: aStream [
	aStream
		nextPutAll: 'Diff('; 
		print: self diffs size;
		nextPutAll: ' items)'
]
