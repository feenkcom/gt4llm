Extension { #name : #GtPharoMethodCoderViewModel }

{ #category : #'*Gt4OpenAI-GToolkit' }
GtPharoMethodCoderViewModel >> llmChat [
	^ GtLlmMethodAssistant new chatOn: self
]
