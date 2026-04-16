Extension { #name : #SmaCCRewriteMethodDefinition }

{ #category : #'*Gt4Llm-SmaCC-Transformations' }
SmaCCRewriteMethodDefinition >> asLlmSpecification [
	^ GtLSmaCCRewriteMethodSpecification new
		comment: self comment;
		source: self source;
		yourself
]
