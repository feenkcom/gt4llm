Extension { #name : #GtPharoSnippetCoderViewModel }

{ #category : #'*Gt4OpenAI-GToolkit' }
GtPharoSnippetCoderViewModel >> llmChat [
	^ self coderModel
		attributeNamed: #llmChat
		ifAbsent: [ self coderModel
				attributeNamed: #llmChat
				put: (GtLlmCodeSnippetTutor new chatOn: self) ]
]
