Extension { #name : #GtLlmNewThreadMessage }

{ #category : #'*Gt4Llm-GToolkit' }
GtLlmNewThreadMessage >> asViewModel [
	^ GtLlmNewThreadMessageViewModel new threadMessage: self
]

{ #category : #'*Gt4Llm-GToolkit' }
GtLlmNewThreadMessage >> elementClass [
	^ GtLlmNewThreadMessageElement
]
