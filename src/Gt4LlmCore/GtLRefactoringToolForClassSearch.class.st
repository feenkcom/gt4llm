Class {
	#name : #GtLRefactoringToolForClassSearch,
	#superclass : #GtLAbstractFunctionTool,
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
GtLRefactoringToolForClassSearch >> parameters [
	^ #('query')
]

{ #category : #'llm-generated' }
GtLRefactoringToolForClassSearch >> privatePerformToolCall: aToolCall [
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
