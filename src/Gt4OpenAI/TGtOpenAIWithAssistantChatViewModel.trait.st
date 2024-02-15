Trait {
	#name : #TGtOpenAIWithAssistantChatViewModel,
	#instVars : [
		'assistantChatViewModel'
	],
	#category : #'Gt4OpenAI-Widgets'
}

{ #category : #accessing }
TGtOpenAIWithAssistantChatViewModel >> assistantChat [
	^ assistantChatViewModel assistantChat
]

{ #category : #convenience }
TGtOpenAIWithAssistantChatViewModel >> assistantChat: anAssistantChat [
	self
		assistantChatViewModel: (GtOpenAIAssistantChatViewModel new assistantChat: anAssistantChat)
]

{ #category : #accessing }
TGtOpenAIWithAssistantChatViewModel >> assistantChatViewModel [
	^ assistantChatViewModel
]

{ #category : #accessing }
TGtOpenAIWithAssistantChatViewModel >> assistantChatViewModel: anObject [
	assistantChatViewModel = anObject ifTrue: [ ^ self ].
	assistantChatViewModel ifNotNil: [ self unsubscribeFromAssistantChatViewModel ].
	assistantChatViewModel := anObject.
	self onAssistantChatViewModelChanged.
	self subscribeToAssistantChatViewModel.
]

{ #category : #'private - hooks' }
TGtOpenAIWithAssistantChatViewModel >> onAssistantChatViewModelChanged [
]

{ #category : #'private - hooks' }
TGtOpenAIWithAssistantChatViewModel >> subscribeToAssistantChatViewModel [
]

{ #category : #'private - hooks' }
TGtOpenAIWithAssistantChatViewModel >> unsubscribeFromAssistantChatViewModel [
]
