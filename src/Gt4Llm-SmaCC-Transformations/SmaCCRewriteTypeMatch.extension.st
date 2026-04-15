Extension { #name : #SmaCCRewriteTypeMatch }

{ #category : #'*Gt4Llm-SmaCC-Transformations' }
SmaCCRewriteTypeMatch >> asLlmSpecification [
	^ GtSmaCCRewriteTypeMatchSpecification new
		source: self source;
		nodeClass: self nodeClass name;
		yourself
]
