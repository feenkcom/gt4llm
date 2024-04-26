Trait {
	#name : #TGtLlmWithAssistantChat,
	#instVars : [
		'assistantChat'
	],
	#category : #'Gt4Llm-Widgets'
}

{ #category : #accessing }
TGtLlmWithAssistantChat >> assistantChat [
	<return: #TGtLlmWithAssistantChat>
	^ assistantChat
]

{ #category : #accessing }
TGtLlmWithAssistantChat >> assistantChat: anObject [
	assistantChat = anObject ifTrue: [ ^ self ].
	assistantChat ifNotNil: [ self unsubscribeFromAssistantChat ].
	assistantChat := anObject.
	self onAssistantChatChanged.
	self subscribeToAssistantChat.
]

{ #category : #'private - hooks' }
TGtLlmWithAssistantChat >> onAssistantChatChanged [
]

{ #category : #'private - hooks' }
TGtLlmWithAssistantChat >> subscribeToAssistantChat [
]

{ #category : #'private - hooks' }
TGtLlmWithAssistantChat >> unsubscribeFromAssistantChat [
]
