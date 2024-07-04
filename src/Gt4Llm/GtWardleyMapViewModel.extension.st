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
	self optionAt: #openAIWardleyMapCreator put: aCreator
]

{ #category : #'*Gt4Llm' }
GtWardleyMapViewModel >> onActionFinished [
	self wardleyMapModel
		removeWardleyMapDecoratorModel: (self wardleyMapModel wardleyMapDecoratorModels
				detect: [ :aDecorator | aDecorator isKindOf: GtLlmWardleyMapInProgressDecorator ]
				ifNone: [ nil ])
]

{ #category : #'*Gt4Llm' }
GtWardleyMapViewModel >> onActionStarted [
	self wardleyMapModel
		addWardleyMapDecoratorModel: GtLlmWardleyMapInProgressDecorator new
]

{ #category : #'*Gt4Llm' }
GtWardleyMapViewModel >> onSpawnRequest: anAnnouncement [
	self announce: (GtWardleyMapSpawnRequest new object: anAnnouncement object)
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
			aChat weak
				when: GtLlmActionStarted
				send: #onActionStarted
				to: self.
			aChat weak
				when: GtLlmActionFinished
				send: #onActionFinished
				to: self.
			aChat ]
]

{ #category : #'*Gt4Llm' }
GtWardleyMapViewModel >> openAITutorChat: aChat [
	^ self optionAt: #openAITutorChat put: aChat
]
