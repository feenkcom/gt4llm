"
Magritte-based tool for substring literal search.
"
Class {
	#name : #GtLMagritteToolForSubstringLiteralSearch,
	#superclass : #GtLAbstractMagritteFunctionTool,
	#category : #'Gt4LlmCore-Tools'
}

{ #category : #accessing }
GtLMagritteToolForSubstringLiteralSearch >> description [
	^ 'Searches for methods by substring literal match.

Arguments:
- query: string

Return values:
- foundMethods: array of method references
- mayHaveMore: boolean indicating if there are more matches than returned

Example JSON arguments:
{
  "query": "substringLiteralSearch"
}

Example JSON response:
{
  "foundMethods": [
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
GtLMagritteToolForSubstringLiteralSearch >> isUsingDataViews [
	^ true
]

{ #category : #accessing }
GtLMagritteToolForSubstringLiteralSearch >> name [
	^ 'substringLiteralSearch'
]

{ #category : #private }
GtLMagritteToolForSubstringLiteralSearch >> privatePerformToolCall: aToolCall inContext: anExecutionContext [
	| arguments query filter matches |
	arguments := aToolCall arguments ifNil: [ Dictionary new ].
	query := arguments at: 'query'.

	(query trimBoth isEmpty)
		ifTrue: [ ^ GtLMissingArgumentDomainObject new
				arguments: arguments;
				missingArgument: 'query' ].

	filter := query asString gtSubstringLiteralMatch.
	matches := (filter result toArray
		await: GtLSettings futureExecutionConfiguration) wait.

	^ GtLMethodsSearchResult fromReferences: matches
]

{ #category : #accessing }
GtLMagritteToolForSubstringLiteralSearch >> queryDescription [
	<magritteDescription>

	^ MAStringDescription new
		label: 'Query';
		accessor: #query;
		beRequired
]
