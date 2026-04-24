Trait {
	#name : #TGtLWithChat,
	#instVars : [
		'chat'
	],
	#category : #'Gt4LlmCore-Core'
}

{ #category : #'api - chat' }
TGtLWithChat >> chat [
	^ chat
]

{ #category : #'api - chat' }
TGtLWithChat >> chat: aChat [
	self assert: [ aChat isNotNil ].
	
	aChat = chat ifTrue: [ ^ self ].
	
	chat ifNotNil: [ :anOldChat | self unsubscribeFromChat ].
	chat := aChat.
	
	self onChatChanged.
	self subscribeToChat
]

{ #category : #'private - chat' }
TGtLWithChat >> onChatChanged [
	
]

{ #category : #'private - chat' }
TGtLWithChat >> subscribeToChat [
	
]

{ #category : #'private - chat' }
TGtLWithChat >> unsubscribeFromChat [
	
]
