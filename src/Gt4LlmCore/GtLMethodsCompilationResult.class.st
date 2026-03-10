"
Result of compiling multiple methods, containing individual compilation results.
"
Class {
	#name : #GtLMethodsCompilationResult,
	#superclass : #Object,
	#instVars : [
		'methods'
	],
	#category : 'Gt4LlmCore-Magritte Objects'
}

{ #category : #views }
GtLMethodsCompilationResult >> gtMethodsFor: aView [
	<gtView>
	<gtLlmView>
	(self methods anySatisfy: [:each | each isKindOf: GtLMethodCompilationExceptionDomainObject]) ifTrue: [ ^ aView empty ].
	^ aView forward
		title: 'Methods';
		priority: 1;
		object: [ GtSearchFixedMethodsFilter new methods: (self methods collect: [:each | each newCompiledMethod]) ];
		view: #gtItemsFor:
]

{ #category : #views }
GtLMethodsCompilationResult >> gtMethodsListFor: aView [
	<gtView>
	<gtLlmView>
	methods ifNil: [ ^ aView empty ].
	^ aView columnedList
		title: 'Method list';
		priority: 2;
		items: [ methods ];
		column: 'Class' text: [ :each | each newCompiledMethod gtDisplayString ];
		column: 'State'
			text: [ :each | each hasOldSourceCode ifTrue: [ 'Modified' ] ifFalse: [ 'New' ] ]
]

{ #category : #accessing }
GtLMethodsCompilationResult >> methods [
	^ methods ifNil: [ #() ]
]

{ #category : #accessing }
GtLMethodsCompilationResult >> methods: aCollection [
	methods := aCollection
]

{ #category : #magritte }
GtLMethodsCompilationResult >> methodsDescription [
	<magritteDescription>
	^ MAToManyRelationDescription new
		accessor: #methods;
		classes: {
			GtLMethodCompilationResult.
			GtLMethodCompilationExceptionDomainObject.
			GtLMissingDomainObject.
			GtLMissingArgumentDomainObject };
		beRequired
]

{ #category : #printing }
GtLMethodsCompilationResult >> printOn: aStream [
	super printOn: aStream.
	aStream parenthesize: [
		aStream
			print: self methods size;
			nextPutAll: ' methods' ]
]
