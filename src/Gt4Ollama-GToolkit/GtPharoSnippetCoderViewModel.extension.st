Extension { #name : #GtPharoSnippetCoderViewModel }

{ #category : #'*Gt4Ollama-GToolkit' }
GtPharoSnippetCoderViewModel >> llmChat [
	^ self coderModel
		attributeNamed: #llmChat
		ifAbsent: [ self coderModel
				attributeNamed: #llmChat
				put: (GtCodeSnippetTutor new chatOnCoderViewModel: self) ]
]
