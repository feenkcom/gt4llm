Extension { #name : #GtPharoMethodCoderViewModel }

{ #category : #'*Gt4OpenAI-GToolkit' }
GtPharoMethodCoderViewModel >> llmChat [
	^ GtLlmMethodAsssistant new chatOn: self
]
