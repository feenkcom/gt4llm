Extension { #name : #GtWardleyMapEditorContext }

{ #category : #'*Gt4Llm' }
GtWardleyMapEditorContext >> isAITutorChatAvailable [
	<return: #Boolean>
	^ self wardleyMapViewModel isAITutorChatAvailable
]

{ #category : #'*Gt4Llm' }
GtWardleyMapEditorContext >> isLlmConnected [
	^ self llmCreator isNotNil
]

{ #category : #'*Gt4Llm' }
GtWardleyMapEditorContext >> llmCreator [
	<return: #GtLlmActionWardleyMapCreator or: nil>
	^ self wardleyMapViewModel llmCreator
]
