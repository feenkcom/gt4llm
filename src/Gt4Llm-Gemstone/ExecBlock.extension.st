Extension { #name : #ExecBlock }

{ #category : #'*Gt4Llm-Gemstone' }
ExecBlock >> doWhileTrue: aBlock [
	self value.
	^ aBlock whileTrue: self
]
