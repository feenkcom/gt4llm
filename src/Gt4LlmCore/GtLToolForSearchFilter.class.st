Class {
	#name : #GtLToolForSearchFilter,
	#superclass : #GtLAbstractMagritteFunctionTool,
	#category : #'Gt4LlmCore-Tools'
}

{ #category : #accessing }
GtLToolForSearchFilter class >> maximumResultItemCount [
	^ 100
]

{ #category : #accessing }
GtLToolForSearchFilter >> description [
	^ 'Use GT filters to find methods'
]

{ #category : #accessing }
GtLToolForSearchFilter >> isUsingDataViews [
	^ true
]

{ #category : #accessing }
GtLToolForSearchFilter >> name [
	^ 'gtSearchFilter'
]

{ #category : #accessing }
GtLToolForSearchFilter >> privatePerformToolCall: aToolCall inContext: anExecutionContext [
	| arguments query |
	arguments := aToolCall arguments ifNil: [ Dictionary new ].
	(arguments includesKey: 'query')
		ifFalse: [ ^ GtLMissingArgumentDomainObject new
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
				freeze: error;
				errorReason: 'There was an error when evaluating the query: ' , error printString ]
]

{ #category : #accessing }
GtLToolForSearchFilter >> queryDescription [
	<magritteDescription>

	^ MAStringDescription new
		label: 'Query';
		accessor: #query;
		beRequired
]
