Extension { #name : #SmaCCRewritePropertyDefinition }

{ #category : #'*Gt4Llm-SmaCC-Transformations' }
SmaCCRewritePropertyDefinition >> asLlmSpecification [
	^ GtLSmaCCRewritePropertyDefinitionSpecification new
		comment: self comment;
		localProperties: self locals;
		globalProperties: self globals;
		yourself
]
