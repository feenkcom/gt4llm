Extension { #name : #GtPharoSourceCoder }

{ #category : #'*Gt4LlmCore' }
GtPharoSourceCoder >> llmChatLepiterExplanationAddOnFor: anAST into: coderAddOns [
	<gtAstCoderAddOns: 10>

	coderAddOns addStyler: GtLCoderExpandableLepiterExplanationStyler new
]
