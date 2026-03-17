Class {
	#name : #GtLNotSourceSearchableMethod,
	#superclass : #Object,
	#instVars : [
		'methodReference',
		'sourceCode'
	],
	#category : 'Gt4LlmCore-Magritte Objects'
}

{ #category : #'instance creation' }
GtLNotSourceSearchableMethod class >> fromCompiledMethod: aMethod [ 
	^ self new 
		initializeFromCompiledMethod: aMethod 
]

{ #category : #accessing }
GtLNotSourceSearchableMethod >> compiledMethod [
	^ self methodReference compiledMethod
]

{ #category : #'gt - extensions' }
GtLNotSourceSearchableMethod >> gtClassCoderViewFor: aView [
	<gtView>
	<gtLlmView>
	^ aView explicit
		title: 'Coder';
		priority: 1;
		stencil: [ (GtCoderElement forMethod: self compiledMethod) disablePlayPage ]
]

{ #category : #initialization }
GtLNotSourceSearchableMethod >> initializeFromCompiledMethod: aMethod [ 
	methodReference := GtLMethodReference fromCompiledMethod: aMethod.
	sourceCode := '<not searchable method>'
]

{ #category : #accessing }
GtLNotSourceSearchableMethod >> isClassSide [
	^ self methodReference isClassSide
]

{ #category : #accessing }
GtLNotSourceSearchableMethod >> methodClass [
	^ self methodReference methodClass
]

{ #category : #accessing }
GtLNotSourceSearchableMethod >> methodClassName [
	^ self methodReference methodClassName
]

{ #category : #accessing }
GtLNotSourceSearchableMethod >> methodName [
	^ self methodReference methodName
]

{ #category : #accessing }
GtLNotSourceSearchableMethod >> methodReference [
	^ methodReference
]

{ #category : #accessing }
GtLNotSourceSearchableMethod >> methodReference: anObject [
	methodReference := anObject
]

{ #category : #descriptions }
GtLNotSourceSearchableMethod >> methodReferenceDescription [
	<magritteDescription>
	
	^ MAToOneRelationDescription new
			accessor: #methodReference;
			classes: {GtLMethodReference};
			beRequired
]

{ #category : #accessing }
GtLNotSourceSearchableMethod >> sourceCode [
	^ sourceCode
]

{ #category : #accessing }
GtLNotSourceSearchableMethod >> sourceCode: anObject [
	sourceCode := anObject
]

{ #category : #descriptions }
GtLNotSourceSearchableMethod >> sourceCodeDescription [
	<magritteDescription>
	
	^ MAStringDescription new
		label: 'Source code';
		accessor: #sourceCode;
		beRequired
]
