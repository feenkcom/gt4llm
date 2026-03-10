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
	^ aView list
		title: 'Methods';
		priority: 1;
		items: [ self methods ];
		itemText: [ :each |
			each isErrorDomainObject
				ifTrue: [ each printString ]
				ifFalse: [ 
					(each newMethod ifNotNil: [ :m | m methodReference methodSignature ] ifNil: [ '?' ]),
					' — ', each status ] ]
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
