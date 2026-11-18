Extension { #name : #BrMenuItemGroupConfiguration }

{ #category : #'*Gt4LlmCore' }
BrMenuItemGroupConfiguration class >> llm [
	^ self new
		name: (GtLConnectionRegistry instance defaultConnection
				ifNil: [ #Llm ]
				ifNotNil: [ :v | v label ]);
		priority: 45
]
