Extension { #name : #GtHome }

{ #category : #'*Gt4Llm' }
GtHome >> gt4llmSection [
	"<gtHomeSection>"
	Gt4LlmHomeSection shouldShowSection ifFalse: [ ^ GtHomeEmptySection new ].
	
	^ Gt4LlmHomeSection new
		priority: 5
]
