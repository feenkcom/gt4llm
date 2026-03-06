"
Holds method reference results for LLM tools.
"
Class {
	#name : #GtLMethodReferences,
	#superclass : #Object,
	#instVars : [
		'methods',
		'mayHaveMore'
	],
	#category : #Gt4LlmCore
}

{ #category : #'instance creation' }
GtLMethodReferences class >> fromReferences: aCollection [
	| limitedReferences |
	limitedReferences := (aCollection first: (200 min: aCollection size))
		collect: [ :each | GtLMethodReference fromCompiledMethod: each ].
	^ self new
		methods: limitedReferences;
		mayHaveMore: aCollection size > 200;
		yourself
]

{ #category : #views }
GtLMethodReferences >> gtMethodsFor: aView [
	<gtView>
	<gtLlmView>
	self methods ifEmpty: [ ^ aView empty ].
	^ aView columnedList
		title: 'Methods';
		items: [ self methods ];
		column: 'Method' text: [ :each | each methodSignature ]
]

{ #category : #accessing }
GtLMethodReferences >> mayHaveMore [
	^ mayHaveMore ifNil: [ false ]
]

{ #category : #accessing }
GtLMethodReferences >> mayHaveMore: aBoolean [
	mayHaveMore := aBoolean
]

{ #category : #accessing }
GtLMethodReferences >> mayHaveMoreDescription [
	<magritteDescription>

	^ MABooleanDescription new
		label: 'May have more';
		accessor: #mayHaveMore;
		beRequired
]

{ #category : #accessing }
GtLMethodReferences >> methods [
	^ methods ifNil: [ #() ]
]

{ #category : #accessing }
GtLMethodReferences >> methods: aCollection [
	methods := aCollection
]

{ #category : #accessing }
GtLMethodReferences >> methodsDescription [
	<magritteDescription>

	^ MAToManyRelationDescription new
		label: 'Methods';
		accessor: #methods;
		classes: { GtLMethodReference };
		beRequired
]

{ #category : #printing }
GtLMethodReferences >> printOn: aStream [
	super printOn: aStream.
	aStream parenthesize: [
		aStream
			nextPutAll: self methods size asString;
			nextPutAll: ' methods'.
		self mayHaveMore ifTrue: [ aStream nextPutAll: ' (more available)' ] ]
]
