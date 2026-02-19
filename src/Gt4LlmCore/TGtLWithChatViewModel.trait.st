Trait {
	#name : #TGtLWithChatViewModel,
	#instVars : [
		'chatViewModel'
	],
	#category : 'Gt4LlmCore-UI - View Models'
}

{ #category : #'api - chat view model' }
TGtLWithChatViewModel >> chatViewModel [
	^ chatViewModel
]

{ #category : #'api - chat view model' }
TGtLWithChatViewModel >> chatViewModel: aChatViewModel [
	self assert: [ aChatViewModel isNotNil ].

	chatViewModel = aChatViewModel ifTrue: [ ^ self ].
	
	chatViewModel ifNotNil: [ self unsubscribeFromChatViewModel ].
	chatViewModel := aChatViewModel.
	
	self onChatViewModelChanged.
	self subscribeToChatViewModel
]

{ #category : #'private - chat view model' }
TGtLWithChatViewModel >> onChatViewModelChanged [
]

{ #category : #'private - chat view model' }
TGtLWithChatViewModel >> subscribeToChatViewModel [
]

{ #category : #'private - chat view model' }
TGtLWithChatViewModel >> unsubscribeFromChatViewModel [
]
