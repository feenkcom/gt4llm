Class {
	#name : #GtLlmRefactoringToolForClassSearch,
	#superclass : #GtLlmAbstractFunctionTool,
	#instVars : [
		'model'
	],
	#category : #'Gt4Llm-Refactoring'
}

{ #category : #'as yet unclassified' }
GtLlmRefactoringToolForClassSearch class >> leJsonV4Name [
	^ #gtLlmRefactoringToolForClassSearch
]

{ #category : #'llm-generated' }
GtLlmRefactoringToolForClassSearch >> classNames [
	| names |
	names := OrderedCollection new.
	self model
		allClassesDo: [ :each | each isMeta ifFalse: [ names add: each name asString ] ].
	^ names
]

{ #category : #'llm-generated' }
GtLlmRefactoringToolForClassSearch >> description [
	^ 'Searches for classes by name matching the query substring (case-insensitive).'
]

{ #category : #'llm-generated' }
GtLlmRefactoringToolForClassSearch >> model [
	^ model
]

{ #category : #'llm-generated' }
GtLlmRefactoringToolForClassSearch >> model: aModel [
	model := aModel
]

{ #category : #'llm-generated' }
GtLlmRefactoringToolForClassSearch >> name [
	^ 'rbSearchForClasses'
]

{ #category : #'llm-generated' }
GtLlmRefactoringToolForClassSearch >> parameters [
	^ #('query')
]

{ #category : #'llm-generated' }
GtLlmRefactoringToolForClassSearch >> privatePerformToolCall: aToolCall [
	| arguments query |
	self model ifNil: [ ^ 'Model not provided' ].
	arguments := aToolCall arguments ifNil: [ Dictionary new ].
	query := arguments at: 'query' ifAbsent: [ ^ 'Query not provided' ].
	^ STONJSON
		toString: (GtSpotterSubstringsFilter new
			withWordsSplitter;
			beCaseSensitiveByCapitalization;
			applyInScope: self classNames asAsyncStream
			context: (GtSpotterContext new searchQuery: query)) toArray wait
]
