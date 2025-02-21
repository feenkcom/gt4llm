Extension { #name : #GtPharoMethodCoder }

{ #category : #'*Gt4OpenAI' }
GtPharoMethodCoder >> actionFormatAddOnFor: anAST into: coderAddOns [
	<gtAstCoderAddOns: 10>
	(self behavior includesBehavior: GtLlmTutor) ifFalse: [ ^ self ].

	coderAddOns addStyler: (GtLlmTutorFormatStyler new tutor: self behavior new)
]
