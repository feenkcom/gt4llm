Extension { #name : #GtPharoSourceCoder }

{ #category : #'*Gt4LlmCore' }
GtPharoSourceCoder >> llmChatLepiterExplanationAddOnFor: anAST into: coderAddOns [
	<gtAstCoderAddOns: 10>
	self isForSmalltalkCode ifFalse: [ ^ self ].
	coderAddOns addStyler: GtLCoderExpandableLepiterExplanationStyler new
]
