Class {
	#name : #GtLToolForSearchFilter,
	#superclass : #GtLAbstractFunctionTool,
	#category : #'Gt4LlmCore-Tools'
}

{ #category : #accessing }
GtLToolForSearchFilter class >> leJsonV4Name [
	^ #gtLToolForSearchFilter
]

{ #category : #accessing }
GtLToolForSearchFilter class >> maximumResultItemCount [
	^ 100
]

{ #category : #accessing }
GtLToolForSearchFilter >> acceptVisitor: aVisitor [
	^ aVisitor visitGtLlmToolForSearchFilter: self
]

{ #category : #accessing }
GtLToolForSearchFilter >> description [
	^ 'Use GT filters to find methods'
]

{ #category : #accessing }
GtLToolForSearchFilter >> name [
	^ 'gtSearchFilter'
]

{ #category : #accessing }
GtLToolForSearchFilter >> parameters [
	^ #('query')
]

{ #category : #accessing }
GtLToolForSearchFilter >> privatePerformToolCall: aToolCall [
	| arguments query |
	arguments := aToolCall arguments ifNil: [ Dictionary new ].
	(arguments includesKey: 'query')
		ifFalse: [ ^ GtLMissingArgumentDomainObject new
				receiverName: self name;
				arguments: arguments;
				missingArgument: 'query' ].
	query := (arguments at: 'query') asString.
	^ [ | result allItems someItems |
	result := OpalCompiler new
			source: query;
			evaluate.
	allItems := result contents.
	someItems := allItems
			first: (self class maximumResultItemCount min: allItems size).

	GtLSearchFilterDomainObject new
		query: query;
		filter: result;
		items: someItems;
		mayHaveMore: allItems size > someItems size ]
		on: Error
		do: [ :error | 
			GtLExceptionDomainObject new
				exception: error;
				description: 'There was an error when evaluating the query: ' , error printString ]
]
