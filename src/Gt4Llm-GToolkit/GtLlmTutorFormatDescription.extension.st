Extension { #name : #GtLlmTutorFormatDescription }

{ #category : #'*Gt4Llm-GToolkit' }
GtLlmTutorFormatDescription >> initializeMethod [
	^ (thisContext stack at: 4) blocDefiningMethod
]
