Extension { #name : #GtWardleyMapViewModel }

{ #category : #'*Gt4Llm' }
GtWardleyMapViewModel >> isAITutorChatAvailable [
	^ self wardleyMapModel isAITutorChatAvailable
]

{ #category : #'*Gt4Llm' }
GtWardleyMapViewModel >> llmCreator [
	<return: #GtLlmActionWardleyMapCreator or: nil>
	self subscribeToLlm.
	^ self wardleyMapModel openAIWardleyMapCreator
]

{ #category : #'*Gt4Llm' }
GtWardleyMapViewModel >> llmCreator: aCreator [
	self subscribeToLlm.
	self wardleyMapModel openAIWardleyMapCreator: aCreator
]

{ #category : #'*Gt4Llm' }
GtWardleyMapViewModel >> onSpawnRequest: anObject [
	self announce: anObject
]

{ #category : #'*Gt4Llm' }
GtWardleyMapViewModel >> subscribeToLlm [
	self wardleyMapModel openAITutorChat unsubscribe: self.
	self wardleyMapModel openAITutorChat weak
		when: GtLlmSpawnRequestAnnouncement
		send: #onSpawnRequest:
		to: self
]
