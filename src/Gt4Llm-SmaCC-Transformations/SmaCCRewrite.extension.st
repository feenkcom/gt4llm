Extension { #name : #SmaCCRewrite }

{ #category : #'*Gt4Llm-SmaCC-Transformations' }
SmaCCRewrite >> asLlmSpecification [
	^ GtLSmaCCRewriteSpecification new
		comment: self comment;
		match: self match asLlmSpecification;
		transformation: self transformation asLlmSpecification;
		yourself
]
