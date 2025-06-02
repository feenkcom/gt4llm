Extension { #name : #GtPharoMethodCoderViewModel }

{ #category : #'*Gt4OpenAI-GToolkit' }
GtPharoMethodCoderViewModel >> llmChat [
	^ self coderModel
		attributeNamed: #llmChat
		ifAbsent: [ self coderModel
				attributeNamed: #llmChat
				put: (GtLlmMethodAssistant new chatOn: self) ]
]
