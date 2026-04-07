"
Result of compiling multiple methods, containing individual compilation results.
"
Class {
	#name : #GtLMethodsCompilationResult,
	#superclass : #Object,
	#instVars : [
		'methods'
	],
	#category : #'Gt4LlmCore-Magritte Objects'
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
		column: 'Class'
			stencil: [ :each | 
				BrExpander new
					vFitContent;
					hMatchParent;
					margin: (BlInsets top: 5 left: 0 bottom: 5 right: 5);
					collapse;
					aptitude: (GtCoderExpanderAptitude new "sidebarExtraPadding: (BlInsets top: 5)");
					header: [ BrEditorElement new
							constraintsDo: [ :c | 
								c horizontal matchParent.
								c vertical fitContent ];
							editor: (BrTextEditorModel new
									text: each newCompiledMethod gtDisplayString asRopedText glamorousRegularFont) ];
					content: [ each asDiffElement ] ];
		column: 'State'
			text: [ :each | each hasOldSourceCode ifTrue: [ 'Modified' ] ifFalse: [ 'New' ] ]
			width: 60
]

{ #category : #'llm views' }
GtLMethodsCompilationResult >> llmRawDataViewFor: aDataView [
	<gtLlmDataView>
	
	^ aDataView magritteObject: [ self ]
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
