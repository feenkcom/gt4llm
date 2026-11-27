Extension { #name : #GtSearchFilter }

{ #category : #'*Gt4LlmCore' }
GtSearchFilter >> llmMatchingMethods [
	| limit methods |
	limit := 50.
	methods := (self result take: limit + 1) toArray wait.
	^ GtLMethodsSearchResult new
		foundMethods: ((methods first: (limit min: methods size))
				collect: [ :each | GtLMethodReference fromCompiledMethod: each ]);
		mayHaveMore: methods size > limit;
		yourself
]

{ #category : #'*Gt4LlmCore' }
GtSearchFilter >> llmMatchingMethodsDataViewFor: aDataView [
	<gtLlmDataView>
	self resultType = GtAsyncSearchMethodGroupStream ifFalse: [ ^ aDataView empty ].
	^ aDataView forwardObject
		title: 'Matching methods';
		dataKey: 'methodMatches';
		object: [ self llmMatchingMethods ]
]
