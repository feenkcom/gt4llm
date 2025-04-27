Extension { #name : #GtPharoMethodCoderViewModel }

{ #category : #'*Gt4OpenAI-GToolkit' }
GtPharoMethodCoderViewModel >> llmChat [
	^ GtLlmMethodTutor new chatOn: self
]
