Extension { #name : #GtPharoSnippetCoderViewModel }

{ #category : #'*Gt4OpenAI' }
GtPharoSnippetCoderViewModel >> llmChat [
	^ self coderModel
		attributeNamed: #llmChat
		ifAbsent: [ self coderModel
				attributeNamed: #llmChat
				put: (GtCodeSnippetTutor new chatOnCoderViewModel: self) ]
]
