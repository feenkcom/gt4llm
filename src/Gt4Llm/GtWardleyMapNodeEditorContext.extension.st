Extension { #name : #GtWardleyMapNodeEditorContext }

{ #category : #'*Gt4Llm' }
GtWardleyMapNodeEditorContext >> isLlmConnected [
	^ self wardleyMapViewModel isAITutorChatAvailable
		and: [ self llmCreator isNotNil ]
]

{ #category : #'*Gt4Llm' }
GtWardleyMapNodeEditorContext >> llmCreator [
	<return: #GtLlmActionWardleyMapCreator or: nil>
	^ self wardleyMapViewModel llmCreator
]
