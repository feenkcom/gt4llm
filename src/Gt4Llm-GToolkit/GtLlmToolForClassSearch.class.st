Class {
	#name : #GtLlmToolForClassSearch,
	#superclass : #GtLlmAbstractFunctionTool,
	#category : #'Gt4Llm-GToolkit'
}

{ #category : #accessing }
GtLlmToolForClassSearch class >> leJsonV4Name [
	^ #gtLlmToolForClassSearch
]

{ #category : #accessing }
GtLlmToolForClassSearch >> acceptVisitor: aVisitor [
	^ aVisitor visitGtLlmToolForClassSearch: self
]

{ #category : #accessing }
GtLlmToolForClassSearch >> description [
	^ 'Searches for classes matching the query substring (case-insensitive).'
]

{ #category : #accessing }
GtLlmToolForClassSearch >> name [
	^ 'searchClasses'
]

{ #category : #accessing }
GtLlmToolForClassSearch >> parameters [
	^ #('query')
]

{ #category : #accessing }
GtLlmToolForClassSearch >> privatePerformToolCall: aToolCall [
	| arguments query matches |
	arguments := aToolCall arguments ifNil: [ Dictionary new ].
	query := arguments at: 'query' ifAbsent: [ ^ 'Query not provided' ].
	matches := ((GtSpotterSubstringsFilter new
		withWordsSplitter;
		beCaseSensitiveByCapitalization;
		applyInScope: SystemNavigation default allClassesAndTraits asAsyncStream
			context: (GtSpotterContext new searchQuery: query)) toArray wait) collect: #name.
	^ STONJSON toString: matches
]
