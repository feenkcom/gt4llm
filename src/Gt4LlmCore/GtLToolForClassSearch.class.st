Class {
	#name : #GtLToolForClassSearch,
	#superclass : #GtLAbstractPlainSchemaFunctionTool,
	#category : #'Gt4LlmCore-Tools'
}

{ #category : #accessing }
GtLToolForClassSearch class >> leJsonV4Name [
	^ #gtLToolForClassSearch
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
GtLToolForClassSearch >> parametersDescription [
	^ #('query')
]

{ #category : #accessing }
GtLToolForClassSearch >> privatePerformToolCall: aToolCall [
	| arguments query matches promise |
	arguments := aToolCall arguments ifNil: [ Dictionary new ].
	query := arguments
			at: 'query'
			ifAbsent: [ ^ GtLMissingArgumentDomainObject new
					receiverName: self name;
					arguments: aToolCall arguments;
					missingArgument: 'query' ].

	promise := (GtSpotterSubstringsFilter new
			withWordsSplitter;
			beCaseSensitiveByCapitalization;
			applyInScope: SystemNavigation default allClassesAndTraits asAsyncStream
				context: (GtSpotterContext new searchQuery: query)) toArray
			await: GtLSettings futureExecutionConfiguration.
	matches := promise wait.
	
	^ GtLClassesDomainObject new 
		foundClasses: (matches first: (200 min: matches size));
		mayHaveMore: matches size > 200
]
