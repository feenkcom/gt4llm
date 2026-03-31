"
Holds subclass name results for LLM tools.
"
Class {
	#name : #GtLClassSubclasses,
	#superclass : #Object,
	#instVars : [
		'givenClassName',
		'subclassNames',
		'mayHaveMore'
	],
	#category : #'Gt4LlmCore-Magritte Objects'
}

{ #category : #'instance creation' }
GtLClassSubclasses class >> fromClasses: aCollection [
	| matchesArray limited |
	matchesArray := aCollection asArray.
	limited := matchesArray first: (200 min: matchesArray size).
	^ self new
		subclassNames:  (limited collect: [ :each | each name ]);
		mayHaveMore: matchesArray size > 200;
		yourself
]

{ #category : #accessing }
GtLClassSubclasses >> givenClassName [
	^ givenClassName
]

{ #category : #accessing }
GtLClassSubclasses >> givenClassName: aString [
	givenClassName := aString
]

{ #category : #magritte }
GtLClassSubclasses >> givenClassNameDescription [
	<magritteDescription>

	^ MAStringDescription new
		label: 'Given class name';
		accessor: #givenClassName;
		beRequired
]

{ #category : #'gt-view' }
GtLClassSubclasses >> gtSubclassNamesFor: aView [
	<gtView>
	<gtLlmView>
	self subclassNames ifNil: [ ^ aView empty ].
	^ aView list
		title: 'Subclasses';
		priority: 1;
		items: [ self subclassNames ];
		itemText: [ :each | each ]
]

{ #category : #'gt-view' }
GtLClassSubclasses >> gtSummaryFor: aView [
	<gtView>
	^ aView text
		title: 'Summary';
		priority: 2;
		text: [ String streamContents: [ :stream |
			self givenClassName ifNotNil: [ :aName |
				stream
					nextPutAll: 'Class: ';
					nextPutAll: aName;
					nextPutAll: ' — ' ].
			stream
				nextPutAll: self subclassNames size asString;
				nextPutAll: ' subclasses'.
			self mayHaveMore ifTrue: [ stream nextPutAll: ' (more available)' ] ] ]
]

{ #category : #'llm views' }
GtLClassSubclasses >> llmRawDataViewFor: aDataView [
	<gtLlmDataView>
	
	^ aDataView magritteObject: [ self ]
]

{ #category : #accessing }
GtLClassSubclasses >> mayHaveMore [
	^ mayHaveMore
]

{ #category : #accessing }
GtLClassSubclasses >> mayHaveMore: aBoolean [
	mayHaveMore := aBoolean
]

{ #category : #magritte }
GtLClassSubclasses >> mayHaveMoreDescription [
	<magritteDescription>

	^ MABooleanDescription new
		label: 'May have more';
		accessor: #mayHaveMore;
		beRequired
]

{ #category : #printing }
GtLClassSubclasses >> printOn: aStream [
	super printOn: aStream.
	aStream
		parenthesize: [ self givenClassName
				ifNotNil: [ :aName | 
					aStream
						nextPutAll: 'Class: ';
						nextPutAll: aName;
						nextPutAll: ' — ' ].
			aStream
				nextPutAll: self subclassNames size asString;
				nextPutAll: ' subclasses' ]
]

{ #category : #accessing }
GtLClassSubclasses >> subclassNames [
	^ subclassNames
]

{ #category : #accessing }
GtLClassSubclasses >> subclassNames: aCollection [
	subclassNames := aCollection
]

{ #category : #magritte }
GtLClassSubclasses >> subclassNamesDescription [
	<magritteDescription>

	^ MAToManyScalarRelationDescription new
		label: 'Subclass names';
		accessor: #subclassNames;
		classes: { String };
		beRequired
]
