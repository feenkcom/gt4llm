"
Magritte-based tool for searching classes in a GtRBNamespace model.
"
Class {
	#name : #GtLRefactoringToolForClassSearch,
	#superclass : #GtLAbstractRefactoringMagritteTool,
	#category : #'Gt4LlmCore-Tools'
}

{ #category : #'llm-generated' }
GtLRefactoringToolForClassSearch >> classNames [
	| names |
	names := OrderedCollection new.
	self model
		allClassesDo: [ :each | each isMeta ifFalse: [ names add: each name asString ] ].
	^ names
]

{ #category : #'llm-generated' }
GtLRefactoringToolForClassSearch >> description [
	^ 'Searches for classes by name matching the query substring (case-insensitive).'
]

{ #category : #'llm-generated' }
GtLRefactoringToolForClassSearch >> name [
	^ 'rbSearchForClasses'
]

{ #category : #executing }
GtLRefactoringToolForClassSearch >> privatePerformToolCall: aToolCall inContext: anExecutionContext [
	| arguments query promise result allClassNames |
	self model
		ifNil: [ ^ GtLMissingInformationDomainObject new
				missingModelName: 'model' ].
	arguments := aToolCall arguments ifNil: [ Dictionary new ].
	query := arguments at: 'query'.
	allClassNames := self classNames.
	promise := (GtSpotterSubstringsFilter new
			withWordsSplitter;
			beCaseSensitiveByCapitalization;
			applyInScope: allClassNames asAsyncStream
				context: (GtSpotterContext new searchQuery: query)) toArray
			await: GtLSettings futureExecutionConfiguration.
	result := promise wait.

	^ GtLRefactoringClassSearchDomainObject new
		model: self model;
		query: query;
		allClassNames: allClassNames;
		foundClassNames: result
]

{ #category : #magritte }
GtLRefactoringToolForClassSearch >> queryDescription [
	<magritteDescription>
	^ MAStringDescription new
		label: 'Query';
		accessor: #query;
		beRequired
]
