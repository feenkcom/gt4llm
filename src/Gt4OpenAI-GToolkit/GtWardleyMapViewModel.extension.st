Extension { #name : #GtWardleyMapViewModel }

{ #category : #'*Gt4OpenAI-GToolkit' }
GtWardleyMapViewModel >> llm [
	^ self
		optionAt: #llm
		ifAbsentPut: [ GtLlmWardleyMapTutor new createChatOn: self wardleyMapModel ]
]
