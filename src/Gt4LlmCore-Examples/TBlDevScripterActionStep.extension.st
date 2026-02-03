Extension { #name : #TBlDevScripterActionStep }

{ #category : #'*Gt4LlmCore-Examples' }
TBlDevScripterActionStep >> llmChat [
	^ self
		addStep: (GtLChatStep new
				label: 'LLM Chat';
				referenceSender)
]
