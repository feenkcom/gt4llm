Extension { #name : #GtLlmAssistantFormatDescription }

{ #category : #'*Gt4Llm-GToolkit' }
GtLlmAssistantFormatDescription >> initializeMethod [
	^ (thisContext stack at: 4) blocDefiningMethod
]
