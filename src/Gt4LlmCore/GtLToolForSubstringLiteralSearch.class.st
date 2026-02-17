Class {
	#name : #GtLToolForSubstringLiteralSearch,
	#superclass : #GtLAbstractPlainSchemaFunctionTool,
	#category : #'Gt4LlmCore-Tools'
}

{ #category : #serialization }
GtLToolForSubstringLiteralSearch class >> leJsonV4Name [
	^ #gtLToolForSubstringLiteralSearch
]

{ #category : #visiting }
GtLToolForSubstringLiteralSearch >> acceptVisitor: aVisitor [
	^ aVisitor visitGtLToolForSubstringLiteralSearch: self
]

{ #category : #accessing }
GtLToolForSubstringLiteralSearch >> description [
	^ 'Searches for methods by substring literal match.'
]

{ #category : #accessing }
GtLToolForSubstringLiteralSearch >> name [
	^ 'substringLiteralSearch'
]

{ #category : #accessing }
GtLToolForSubstringLiteralSearch >> parametersDescription [
	^ #('query')
]

{ #category : #private }
GtLToolForSubstringLiteralSearch >> privatePerformToolCall: aToolCall [
	| arguments argument query filter promise matches |
	arguments := aToolCall arguments ifNil: [ Dictionary new ].
	argument := aToolCall anyArgument.
	argument
		ifNil: [ ^ GtLMissingArgumentDomainObject new
				receiverName: self name;
				arguments: arguments;
				missingArgument: 'query' ].
	query := argument asString.
	filter := query gtSubstringLiteralMatch.
	promise := filter result toArray
			await: GtLSettings futureExecutionConfiguration.
	matches := promise wait.
	^ GtLMethodsDomainObject new
		methods: (matches first: (100 min: matches size));
		mayHaveMore: matches size > 100
]
