Extension { #name : #GtWardleyMapViewModel }

{ #category : #'*Gt4OpenAI-GToolkit' }
GtWardleyMapViewModel >> llm [
	^ self
		optionAt: #llm
		ifAbsentPut: [ GtLlmWardleyMapAssistant new createChatOn: self wardleyMapModel ]
]
