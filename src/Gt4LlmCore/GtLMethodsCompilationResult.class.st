"
Result of compiling multiple methods, containing individual compilation results.
"
Class {
	#name : #GtLMethodsCompilationResult,
	#superclass : #Object,
	#instVars : [
		'methodCompilationResults'
	],
	#category : #'Gt4LlmCore-Magritte Objects'
}

{ #category : #accessing }
GtLMethodsCompilationResult >> compilationResultsForExistingMethods [
	^ self successfulMethodCompilationResults 
		select: [ :each |
			each existsInImage ]
]

{ #category : #views }
GtLMethodsCompilationResult >> gtCurrentMethodsFor: aView [
	<gtView>
	<gtLlmView>
	
	^ aView forward
		title: 'Methods';
		priority: 1;
		object: [ 
			GtSearchFixedMethodsFilter new 
				methods: (self compilationResultsForExistingMethods 
					collect: [:aMethodCompilationResult | 
						aMethodCompilationResult newCompiledMethod ]) ];
		view: #gtItemsFor:
]

{ #category : #views }
GtLMethodsCompilationResult >> gtMethodCompilationResults1For: aView [
	<gtView>
	methodCompilationResults ifNil: [ ^ aView empty ].
	
	^ aView columnedList
		priority: 40;
		title: 'Compilation results';
		items: [ methodCompilationResults ];
		column: 'Result' text: [ :each | each ]
]

{ #category : #accessing }
GtLMethodsCompilationResult >> gtMethodsListFor: aView [
	<gtView>
	<gtLlmView>
	methodCompilationResults ifNil: [ ^ aView empty ].
	
	^ aView columnedList
		title: 'Method list';
		priority: 2;
		items: [ self compilationResultsForExistingMethods ];
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
	
	^ aDataView forwardCollection
			dataKey: 'methodCompilationResults';
			collection: [ self methodCompilationResults ]
]

{ #category : #accessing }
GtLMethodsCompilationResult >> methodCompilationResults [
	^ methodCompilationResults
]

{ #category : #accessing }
GtLMethodsCompilationResult >> methodCompilationResults: aCollection [
	methodCompilationResults := aCollection
]

{ #category : #accessing }
GtLMethodsCompilationResult >> methods [
	^ self methodCompilationResults
]

{ #category : #accessing }
GtLMethodsCompilationResult >> methods: aCollection [
	self methodCompilationResults: aCollection
]

{ #category : #printing }
GtLMethodsCompilationResult >> printOn: aStream [
	super printOn: aStream.
	aStream parenthesize: [
		aStream
			print: self methodCompilationResults size;
			nextPutAll: ' method compilation results' ]
]

{ #category : #views }
GtLMethodsCompilationResult >> successfulMethodCompilationResults [
	^ (self methodCompilationResults
			reject: [:aMethodCompilationResult | 
				aMethodCompilationResult isErrorDomainObject ]) 
]
