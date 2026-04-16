Extension { #name : #SmaCCRewriteFile }

{ #category : #'*Gt4Llm-SmaCC-Transformations' }
SmaCCRewriteFile >> asLlmSpecification [
	^ GtLSmaCCRewriteFileSpecification new
		filename: self filename path pathString;
		rules: (self rewrites collect: #asLlmSpecification);
		parserClass: self parserClass name;
		yourself
]
