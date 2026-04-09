"
Holds class references for LLM tools.
"
Class {
	#name : #GtLClassReferences,
	#superclass : #Object,
	#instVars : [
		'givenClassName',
		'references',
		'mayHaveMore'
	],
	#category : #'Gt4LlmCore-Magritte Objects'
}

{ #category : #'instance creation' }
GtLClassReferences class >> fromCompiledMethods: aCollection [
	| limitedMethods |
	limitedMethods := aCollection first: (200 min: aCollection size).
	^ self new
		references: (limitedMethods collect: [ :each | 
			GtLMethodReference fromCompiledMethod: each ]);
		mayHaveMore: aCollection size > 200;
		yourself
]

{ #category : #accessing }
GtLClassReferences >> givenClassName [
	^ givenClassName
]

{ #category : #accessing }
GtLClassReferences >> givenClassName: aString [
	givenClassName := aString
]

{ #category : #accessing }
GtLClassReferences >> givenClassNameDescription [
	<magritteDescription>

	^ MAStringDescription new
		label: 'Given class name';
		accessor: #givenClassName;
		beRequired
]

{ #category : #views }
GtLClassReferences >> gtReferencesFor: aView [
	<gtView>
	<gtLlmView>
	self references ifEmpty: [ ^ aView empty ].
	^ aView columnedList
		title: 'References';
		items: [ self references ];
		column: 'Method' text: [ :each | each methodSignature ]
]

{ #category : #'llm views' }
GtLClassReferences >> llmRawDataViewFor: aDataView [
	<gtLlmDataView>
	
	^ aDataView magritteObject: [ self ]
]

{ #category : #accessing }
GtLClassReferences >> mayHaveMore [
	^ mayHaveMore ifNil: [ false ]
]

{ #category : #accessing }
GtLClassReferences >> mayHaveMore: aBoolean [
	mayHaveMore := aBoolean
]

{ #category : #accessing }
GtLClassReferences >> mayHaveMoreDescription [
	<magritteDescription>

	^ MABooleanDescription new
		label: 'May have more';
		accessor: #mayHaveMore;
		beRequired
]

{ #category : #printing }
GtLClassReferences >> printOn: aStream [
	super printOn: aStream.
	aStream parenthesize: [
		self givenClassName ifNotNil: [ :aName |
			aStream
				nextPutAll: 'Class: ';
				nextPutAll: aName;
				nextPutAll: ' — ' ].
		aStream
			nextPutAll: self references size asString;
			nextPutAll: ' references'.
		self mayHaveMore ifTrue: [ aStream nextPutAll: ' (more available)' ] ]
]

{ #category : #accessing }
GtLClassReferences >> references [
	^ references ifNil: [ #() ]
]

{ #category : #accessing }
GtLClassReferences >> references: aCollection [
	references := aCollection
]

{ #category : #accessing }
GtLClassReferences >> referencesDescription [
	<magritteDescription>

	^ MAToManyRelationDescription new
		label: 'References';
		accessor: #references;
		classes: { GtLMethodReference };
		beRequired
]
