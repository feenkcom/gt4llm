Extension { #name : #SmaCCRewriteStringTransformation }

{ #category : #'*Gt4Llm-SmaCC-Transformations' }
SmaCCRewriteStringTransformation >> asLlmSpecification [
	^ GtSmaCCRewriteStringTransformationSpecification new
		pattern: self string;
		yourself
]
