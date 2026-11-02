"
Searches for classes by name matching the query substring (case-insensitive).
"
Class {
	#name : #GtLMagritteToolForClassSearch,
	#superclass : #GtLAbstractMagritteFunctionTool,
	#category : #'Gt4LlmCore-Tools'
}

{ #category : #accessing }
GtLMagritteToolForClassSearch >> description [
	^ 'Searches for classes by name matching the query substring (case-insensitive).

Arguments:
- query: string

Return values:
- foundClassNames: array of class names as strings
- mayHaveMore: boolean indicating if there are more matches than returned

Example JSON arguments:
{
  "query": "Collection"
}

Example JSON response:
{
  "foundClassNames": ["Collection", "CollectionSequence"],
  "mayHaveMore": false
}'
]

{ #category : #accessing }
GtLMagritteToolForClassSearch >> name [
	^ 'searchForClasses'
]

{ #category : #private }
GtLMagritteToolForClassSearch >> privatePerformToolCall: aToolCall inContext: anExecutionContext [
	<gsCode: '	| arguments query matches |
	arguments := aToolCall arguments ifNil: [ Dictionary new ].
	query := arguments at: ''query''.
	query isEmpty ifTrue: [ ^ GtLClassesSearchResult fromClasses: #() ].
	matches := IdentitySet new.
	System myUserProfile symbolList do: [ :dictionary |
		dictionary valuesDo: [ :each |
			(each isClass and: [
				(each name asString findPatternNoCase: { query } startingAt: 1) > 0 ])
				ifTrue: [ matches add: each ] ] ].
	^ GtLClassesSearchResult fromClasses:
		(matches asArray sort: [ :a :b | a name <= b name ])'>
	| arguments query matches promise |
	arguments := aToolCall arguments ifNil: [ Dictionary new ].
	query := arguments	at: 'query'.

	promise := (GtSpotterSubstringsFilter new
			withWordsSplitter;
			beCaseSensitiveByCapitalization;
			applyInScope: SystemNavigation default allClassesAndTraits asAsyncStream
				context: (GtSpotterContext new searchQuery: query)) toArray
			await: GtLSettings futureExecutionConfiguration.
	matches := promise wait.

	^ GtLClassesSearchResult fromClasses: matches
]

{ #category : #descriptions }
GtLMagritteToolForClassSearch >> queryDescription [
	<magritteDescription>

	^ MAStringDescription new
		label: 'Query';
		accessor: #query;
		beRequired
]
