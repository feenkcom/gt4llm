Class {
	#name : #GtLMethodWithSource,
	#superclass : #Object,
	#instVars : [
		'methodReference',
		'sourceCode'
	],
	#category : #'Gt4LlmCore-Magritte Objects'
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

{ #category : #testing }
GtLMethodWithSource >> existsInImage [
	^ self methodReference existsInImage
]

{ #category : #views }
GtLMethodWithSource >> gtActionBrowseEntryFor: anAction [
	<gtAction>
	
	self methodReference existsInImage ifFalse: [ ^ anAction noAction ].
	
	^ self methodReference gtActionBrowseEntryFor: anAction
]

{ #category : #'gt - extensions' }
GtLMethodWithSource >> gtClassCoderViewFor: aView [
	<gtView>
	<gtLlmView>
	
	self existsInImage ifFalse: [ ^ aView empty ].
	^ aView explicit
		title: 'Current coder';
		priority: 1;
		stencil: [ (GtCoderElement forMethod: self compiledMethod) disablePlayPage ]
]

{ #category : #'gt - extensions' }
GtLMethodWithSource >> gtDiffWithCurrentVersionFor: aView [
	<gtView>
	<gtCodeChangeView>
	^ aView diff
		title: 'Diff (with current)';
		priority: 9;
		from: [ self compiledMethod sourceCode ];
		to: [ self sourceCode ];
		fromLabel: 'Image content:';
		toLabel: 'Method content:';
		styler: GtCodeDiffRBTextStyler new
]

{ #category : #accessing }
GtLMethodWithSource >> gtDisplayOn: aStream [
	aStream << self methodReference methodSignature
]

{ #category : #views }
GtLMethodWithSource >> gtViewPlainSourceCodeFor: aView [
	<gtView>
	^ aView forward
		title: 'Plain source code';
		priority: 5;
		object: [ sourceCode ];
		view: #gtStringFor:
]

{ #category : #initialization }
GtLMethodWithSource >> initializeFromCompiledMethod: aMethod [ 
	methodReference := GtLMethodReference fromCompiledMethod: aMethod.
	sourceCode := aMethod sourceCode
]

{ #category : #testing }
GtLMethodWithSource >> isClassSide [
	^ self methodReference isClassSide
]

{ #category : #'llm views' }
GtLMethodWithSource >> llmRawDataViewFor: aDataView [
	<gtLlmDataView>
	
	^ aDataView magritteObject
			title: 'Method Data';
			object: [ self ]
]

{ #category : #accessing }
GtLMethodWithSource >> methodClass [
	^ self methodReference methodClass
]

{ #category : #accessing }
GtLMethodWithSource >> methodClassName [
	^ self methodReference methodClassName
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
		beRequired
]
