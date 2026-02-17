Class {
	#name : #GtLRefactoringToolForClassSearch,
	#superclass : #GtLAbstractPlainSchemaFunctionTool,
	#instVars : [
		'model'
	],
	#category : #'Gt4LlmCore-Tools'
}

{ #category : #'as yet unclassified' }
GtLRefactoringToolForClassSearch class >> leJsonV4Name [
	^ #gtLRefactoringToolForClassSearch
]

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
GtLRefactoringToolForClassSearch >> model [
	^ model
]

{ #category : #'llm-generated' }
GtLRefactoringToolForClassSearch >> model: aModel [
	model := aModel
]

{ #category : #'llm-generated' }
GtLRefactoringToolForClassSearch >> name [
	^ 'rbSearchForClasses'
]

{ #category : #'llm-generated' }
GtLRefactoringToolForClassSearch >> parametersDescription [
	^ #('query')
]

{ #category : #'llm-generated' }
GtLRefactoringToolForClassSearch >> privatePerformToolCall: aToolCall [
	| arguments query promise result allClassNames |
	self model
		ifNil: [ ^ GtLMissingInformationDomainObject new
				receiverName: self name;
				missingModelName: 'model' ].
	arguments := aToolCall arguments ifNil: [ Dictionary new ].
	query := arguments
			at: 'query'
			ifAbsent: [ ^ GtLMissingArgumentDomainObject new
					receiverName: self name;
					arguments: arguments;
					missingArgument: 'query' ].
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
