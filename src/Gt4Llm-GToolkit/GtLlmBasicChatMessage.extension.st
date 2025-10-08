Extension { #name : #GtLlmBasicChatMessage }

{ #category : #'*Gt4Llm-GToolkit' }
GtLlmBasicChatMessage >> asViewModel [
	^ GtLlmThreadMessageViewModel new threadMessage: self
]
