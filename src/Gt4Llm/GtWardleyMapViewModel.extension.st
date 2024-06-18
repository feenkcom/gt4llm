Extension { #name : #GtWardleyMapViewModel }

{ #category : #'*Gt4Llm' }
GtWardleyMapViewModel >> isAITutorChatAvailable [
	^ self
		optionAt: #openAITutorChat
		ifPresent: [ true ]
		ifAbsent: [ GtOpenAIGtTutor isTutorAvailable  ]
]

{ #category : #'*Gt4Llm' }
GtWardleyMapViewModel >> llmCreator [
	<return: #GtLlmActionWardleyMapCreator or: nil>
	^ self
		optionAt: #openAIWardleyMapCreator
		ifAbsent: [ self openAITutorChat pipeline instance ]
]

{ #category : #'*Gt4Llm' }
GtWardleyMapViewModel >> llmCreator: aCreator [
	self wardleyMapModel openAIWardleyMapCreator: aCreator
]

{ #category : #'*Gt4Llm' }
GtWardleyMapViewModel >> onSpawnRequest: anObject [
	self announce: anObject
]

{ #category : #'*Gt4Llm' }
GtWardleyMapViewModel >> openAITutorChat [
	^ self
		optionAt: #openAITutorChat
		ifAbsentPut: [ | aChat |
			aChat := GtOpenAIWardleyMapActionTutor instance addChat
					initializeWardleyMapModel: self wardleyMapModel;
					yourself.
			aChat weak
				when: GtLlmSpawnRequestAnnouncement
				send: #onSpawnRequest:
				to: self.
			aChat ]
]
