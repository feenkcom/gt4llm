Extension { #name : #SmaCCRewriteCodeTransformation }

{ #category : #'*Gt4Llm-SmaCC-Transformations' }
SmaCCRewriteCodeTransformation >> asLlmSpecification [
	^ GtSmaCCRewriteCodeTransformationSpecification new
		source: self code;
		yourself
]
