Class {
	#name : #GtLMethodWithSource,
	#superclass : #Object,
	#instVars : [
		'methodReference',
		'sourceCode'
	],
	#category : 'Gt4LlmCore-Domain Objects'
}

{ #category : #'instance creation' }
GtLMethodWithSource class >> fromCompiledMethod: aMethod [ 
	^ self new 
		initializeFromCompiledMethod: aMethod 
]

{ #category : #visiting }
GtLMethodWithSource >> acceptVisitor: aVisitor [
	^ aVisitor visitMethodDomainObject: self
]

{ #category : #'gt - extensions' }
GtLMethodWithSource >> compiledMethod [
	^ self methodReference compiledMethod
]

{ #category : #'gt - extensions' }
GtLMethodWithSource >> gtClassCoderViewFor: aView [
	<gtView>
	<gtLlmView>
	^ aView explicit
		title: 'Coder';
		priority: 1;
		stencil: [ (GtCoderElement forMethod: self compiledMethod) disablePlayPage ]
]

{ #category : #views }
GtLMethodWithSource >> gtViewPlainSourceCodeFor: aView [
	<gtView>
	^ aView forward
		title: 'Plain source code';
		priority: 40;
		object: [ sourceCode ];
		view: #gtStringFor:
]

{ #category : #initialization }
GtLMethodWithSource >> initializeFromCompiledMethod: aMethod [ 
	methodReference := GtLMethodReference fromCompiledMethod: aMethod.
	sourceCode := aMethod sourceCode
]

{ #category : #accessing }
GtLMethodWithSource >> methodClassName [
	^ self methodReference targetClassName
]

{ #category : #accessing }
GtLMethodWithSource >> methodName [
	^ self methodReference methodName
]

{ #category : #accessing }
GtLMethodWithSource >> methodReference [
	^ methodReference
]

{ #category : #accessing }
GtLMethodWithSource >> methodReference: anObject [
	methodReference := anObject
]

{ #category : #descriptions }
GtLMethodWithSource >> methodReferenceDescription [
	<magritteDescription>
	
	^ MAToOneRelationDescription new
			accessor: #methodReference;
			classes: {GtLMethodReference};
			beRequired
]

{ #category : #accessing }
GtLMethodWithSource >> printOn: aStream [ 
	super printOn: aStream.
	
	aStream parenthesize: [
		aStream << self methodReference methodSignature]
]

{ #category : #accessing }
GtLMethodWithSource >> selector [
	^ self methodName asSymbol
]

{ #category : #accessing }
GtLMethodWithSource >> sourceCode [
	^ sourceCode
]

{ #category : #accessing }
GtLMethodWithSource >> sourceCode: aSourceCode [
	sourceCode := aSourceCode
]

{ #category : #descriptions }
GtLMethodWithSource >> sourceCodeDescription [
	<magritteDescription>
	
	^ MAStringDescription new
		label: 'Source code';
		accessor: #sourceCode;
		beOptional
]
