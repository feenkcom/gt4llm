Extension { #name : #GtWardleyMapModel }

{ #category : #'*Gt4Llm' }
GtWardleyMapModel >> gtMessagesWidgetFor: aView [
	"cannot be a forward because the update wouldn’t work"

	<gtView>
	^ self isAITutorChatAvailable
		ifTrue: [ (self openAITutorChat gtMessagesWidgetFor: aView)
			title: 'Open AI Chat' ]
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
	^ self isAITutorChatAvailable
		ifFalse: [ nil ]
		ifTrue: [ self openAITutorChat pipeline instance ]
]
