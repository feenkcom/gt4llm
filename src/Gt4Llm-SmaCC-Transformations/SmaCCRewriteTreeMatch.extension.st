Extension { #name : #SmaCCRewriteTreeMatch }

{ #category : #'*Gt4Llm-SmaCC-Transformations' }
SmaCCRewriteTreeMatch >> asLlmSpecification [
	^ GtSmaCCRewriteTreeMatchSpecification new
		pattern: self source;
		startingState: self startingState;
		yourself
]
