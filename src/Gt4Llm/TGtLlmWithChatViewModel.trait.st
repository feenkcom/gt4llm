Trait {
	#name : #TGtLlmWithChatViewModel,
	#instVars : [
		'assistantChatViewModel'
	],
	#category : #Gt4Llm
}

{ #category : #accessing }
TGtLlmWithChatViewModel >> assistantChat [
	^ assistantChatViewModel assistantChat
]

{ #category : #convenience }
TGtLlmWithChatViewModel >> assistantChat: anAssistantChat [
	self
		assistantChatViewModel: (GtLlmChatViewModel new assistantChat: anAssistantChat)
]

{ #category : #accessing }
TGtLlmWithChatViewModel >> assistantChatViewModel [
	^ assistantChatViewModel
]

{ #category : #accessing }
TGtLlmWithChatViewModel >> assistantChatViewModel: anObject [
	assistantChatViewModel = anObject ifTrue: [ ^ self ].
	assistantChatViewModel ifNotNil: [ self unsubscribeFromAssistantChatViewModel ].
	assistantChatViewModel := anObject.
	self onAssistantChatViewModelChanged.
	self subscribeToAssistantChatViewModel.
]

{ #category : #'private - hooks' }
TGtLlmWithChatViewModel >> onAssistantChatViewModelChanged [
]

{ #category : #'private - hooks' }
TGtLlmWithChatViewModel >> subscribeToAssistantChatViewModel [
]

{ #category : #'private - hooks' }
TGtLlmWithChatViewModel >> unsubscribeFromAssistantChatViewModel [
]
