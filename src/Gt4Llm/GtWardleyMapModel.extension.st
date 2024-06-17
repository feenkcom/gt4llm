Extension { #name : #GtWardleyMapModel }

{ #category : #'*Gt4Llm' }
GtWardleyMapModel >> gtMessagesWidgetFor: aView [
	"cannot be a forward because the update wouldn’t work"

	<gtView>
	^ self isAITutorChatAvailable
		ifTrue: [ (self openAITutorChat gtMessagesWidgetFor: aView)
			title: 'Open AI Chat';
			priority: 5 ]
		ifFalse: [ aView empty ]
]

{ #category : #'*Gt4Llm' }
GtWardleyMapModel >> isAITutorChatAvailable [
	^ self
		optionAt: #openAITutorChat
		ifPresent: [ true ]
		ifAbsent: [ GtOpenAIGtTutor isTutorAvailable  ]
]

{ #category : #'*Gt4Llm' }
GtWardleyMapModel >> openAITutorChat [
	^ self
		optionAt: #openAITutorChat
		ifAbsentPut: [ GtOpenAIWardleyMapActionTutor instance addChat ]
]

{ #category : #'*Gt4Llm' }
GtWardleyMapModel >> openAIWardleyMapCreator [
	<return: #GtLlmActionWardleyMapCreator or: nil>
	^ self
		optionAt: #openAIWardleyMapCreator
		ifAbsent: [ self isAITutorChatAvailable
				ifTrue: [ self openAITutorChat pipeline instance ]
				ifFalse: [ nil ] ]
]

{ #category : #'*Gt4Llm' }
GtWardleyMapModel >> openAIWardleyMapCreator: aCreator [
	^ self optionAt: #openAIWardleyMapCreator put: aCreator
]
