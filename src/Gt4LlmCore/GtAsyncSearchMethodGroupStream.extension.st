Extension { #name : #GtAsyncSearchMethodGroupStream }

{ #category : #'*Gt4LlmCore' }
GtAsyncSearchMethodGroupStream >> llmMatchingMethods [
	| limit methods |
	limit := 50.
	methods := (self asyncSimilarCopy take: limit + 1) toArray wait.
	^ GtLMethodsSearchResult new
		foundMethods: ((methods first: (limit min: methods size))
				collect: [ :each | GtLMethodReference fromCompiledMethod: each ]);
		mayHaveMore: methods size > limit;
		yourself
]

{ #category : #'*Gt4LlmCore' }
GtAsyncSearchMethodGroupStream >> llmMatchingMethodsDataViewFor: aDataView [
	<gtLlmDataView>
	^ aDataView forwardObject
		title: 'Matching methods';
		dataKey: 'methodMatches';
		object: [ self llmMatchingMethods ]
]
