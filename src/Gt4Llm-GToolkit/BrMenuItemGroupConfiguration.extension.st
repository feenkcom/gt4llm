Extension { #name : #BrMenuItemGroupConfiguration }

{ #category : #'*Gt4Llm-GToolkit' }
BrMenuItemGroupConfiguration class >> llm [
	^ self new
		name: (GtLlmConnectionRegistry instance defaultConnection
				ifNil: [ #AI ]
				ifNotNil: #label);
		priority: 45
]
