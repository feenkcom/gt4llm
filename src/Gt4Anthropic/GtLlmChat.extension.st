Extension { #name : #GtLlmChat }

{ #category : #'*Gt4Anthropic' }
GtLlmChat >> messageClassForAnthropic [
	^ GtAnthropicChatMessage
]

{ #category : #'*Gt4Anthropic' }
GtLlmChat >> messageClassForGemini [
	^ GtLlmChatMessage
]
