Extension { #name : #GtLlmNewActionThreadMessage }

{ #category : #'*Gt4Llm-GToolkit' }
GtLlmNewActionThreadMessage >> asViewModel [
	^ GtLlmNewActionThreadMessageViewModel new threadMessage: self
]
