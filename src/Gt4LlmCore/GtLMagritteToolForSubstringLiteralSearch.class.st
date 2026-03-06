"
Magritte-based tool for substring literal search.
"
Class {
	#name : #GtLMagritteToolForSubstringLiteralSearch,
	#superclass : #GtLAbstractMagritteFunctionTool,
	#category : #Gt4LlmCore
}

{ #category : #accessing }
GtLMagritteToolForSubstringLiteralSearch >> description [
	^ 'Searches for methods by substring literal match.

Arguments:
- query: string

Return values:
- methods: array of method references
- mayHaveMore: boolean indicating if there are more matches than returned

Example JSON arguments:
{
  "query": "substringLiteralSearch"
}

Example JSON response:
{
  "methods": [
    {
      "methodClassName": "GtLToolForSubstringLiteralSearch",
      "methodName": "privatePerformToolCall:inContext:",
      "classSide": false
    }
  ],
  "mayHaveMore": false
}'
]

{ #category : #accessing }
GtLMagritteToolForSubstringLiteralSearch >> name [
	^ 'substringLiteralSearch'
]

{ #category : #private }
GtLMagritteToolForSubstringLiteralSearch >> privatePerformToolCall: aToolCall inContext: anExecutionContext [
	| arguments query filter matches |
	arguments := aToolCall arguments ifNil: [ Dictionary new ].
	query := arguments
		at: 'query'
		ifAbsent: [ ^ GtLMissingArgumentDomainObject new
				arguments: arguments;
				missingArgument: 'query' ].

	(query isNil or: [ query trimBoth isEmpty ])
		ifTrue: [ ^ GtLMissingArgumentDomainObject new
				arguments: arguments;
				missingArgument: 'query' ].

	filter := query asString gtSubstringLiteralMatch.
	matches := (filter result toArray
		await: GtLSettings futureExecutionConfiguration) wait.

	^ GtLMethodReferences fromReferences: matches
]

{ #category : #accessing }
GtLMagritteToolForSubstringLiteralSearch >> queryDescription [
	<magritteDescription>

	^ MAStringDescription new
		label: 'Query';
		accessor: #query;
		beRequired
]
