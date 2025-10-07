Class {
	#name : #GtLlmToolForClassSearch,
	#superclass : #GtLlmAbstractFunctionTool,
	#category : #'Gt4Llm-GToolkit'
}

{ #category : #'llm-generated' }
GtLlmToolForClassSearch >> acceptVisitor: aVisitor [
	^ aVisitor visitGtLlmToolForClassSearch: self
]

{ #category : #'llm-generated' }
GtLlmToolForClassSearch >> description [
	^ 'Searches for classes matching the query substring (case-insensitive).'
]

{ #category : #'llm-generated' }
GtLlmToolForClassSearch >> name [
	^ 'searchClasses'
]

{ #category : #'llm-generated' }
GtLlmToolForClassSearch >> parameters [
	^ #('query')
]

{ #category : #'llm-generated' }
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
