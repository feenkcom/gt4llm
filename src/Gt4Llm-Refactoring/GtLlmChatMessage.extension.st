Extension { #name : #GtLlmChatMessage }

{ #category : #'*Gt4Llm-Refactoring' }
GtLlmChatMessage >> gtIsTransformationMessage [
	| json |
	json := self contentJson.
	^ (json includesKey: 'Pharo Transformations')
		and: [ (STONJSON fromString: (self contentJson at: 'Pharo Transformations')) notEmpty ]
]
