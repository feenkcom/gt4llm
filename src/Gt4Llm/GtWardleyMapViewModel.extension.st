Extension { #name : #GtWardleyMapViewModel }

{ #category : #'*Gt4Llm' }
GtWardleyMapViewModel >> isAITutorChatAvailable [
	^ self wardleyMapModel isAITutorChatAvailable
]

{ #category : #'*Gt4Llm' }
GtWardleyMapViewModel >> llmCreator [
	<return: #GtLlmActionWardleyMapCreator or: nil>
	^ self wardleyMapModel openAIWardleyMapCreator
]

{ #category : #'*Gt4Llm' }
GtWardleyMapViewModel >> llmCreator: aCreator [
	^ self wardleyMapModel openAIWardleyMapCreator: aCreator
]
