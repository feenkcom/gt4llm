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
	^ 'Searches for methods by substring literal match. Each method is listed once, at the class or trait that defines it; classes that get it from a trait are not listed.

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
      "methodClassName": "GtLMagritteToolForSubstringLiteralSearch",
      "methodName": "name",
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
	| arguments query matches |
	arguments := aToolCall arguments ifNil: [ Dictionary new ].
	query := arguments at: 'query'.

	(query trimBoth isEmpty)
		ifTrue: [ ^ GtLMissingArgumentDomainObject new
				arguments: arguments;
				missingArgument: 'query' ].

	matches := self
		gtDo: [
			| filter |
			filter := query asString gtSubstringLiteralMatch.
			(filter result toArray
				await: GtLSettings futureExecutionConfiguration) wait ]
		gemstoneDo: [
			| organizer methods matchesLiteral |
			organizer := ClassOrganizer gtDefault.
			methods := IdentitySet new.
			matchesLiteral := [ :literal |
				(literal isString and: [
					literal isSymbol not and: [
						(literal findPatternNoCase: { query asString } startingAt: 1) > 0 ] ])
					or: [ (literal isKindOf: Array) and: [
						literal anySatisfy: matchesLiteral ] ] ].
			organizer classes do: [ :class |
				{ class. class class } do: [ :behavior |
					(behavior _fullMethodDictEnv: organizer environmentId) valuesDo: [ :method |
						(method literals anySatisfy: matchesLiteral)
							ifTrue: [ methods add: method ] ] ] ].
			methods asArray ].

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
