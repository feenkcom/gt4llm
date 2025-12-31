Class {
	#name : #GtLToolForClassSearch,
	#superclass : #GtLAbstractFunctionTool,
	#category : #'Gt4LlmCore-Tools'
}

{ #category : #accessing }
GtLToolForClassSearch class >> leJsonV4Name [
	^ #gtLlmToolForClassSearch
]

{ #category : #accessing }
GtLToolForClassSearch >> acceptVisitor: aVisitor [
	^ aVisitor visitGtLlmToolForClassSearch: self
]

{ #category : #accessing }
GtLToolForClassSearch >> description [
	^ 'Searches for classes by name matching the query substring (case-insensitive).'
]

{ #category : #accessing }
GtLToolForClassSearch >> name [
	^ 'searchForClasses'
]

{ #category : #accessing }
GtLToolForClassSearch >> parameters [
	^ #('query')
]

{ #category : #accessing }
GtLToolForClassSearch >> privatePerformToolCall: aToolCall [
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
