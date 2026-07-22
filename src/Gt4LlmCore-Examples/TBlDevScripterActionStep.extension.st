Extension { #name : #TBlDevScripterActionStep }

{ #category : #'*Gt4LlmCore-Examples' }
TBlDevScripterActionStep >> llmChat [
	<scripterActionStep>
	
	^ self
		addStep: (GtLChatStep new
				label: 'LLM Chat';
				referenceSender)
]
