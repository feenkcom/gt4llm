Trait {
	#name : #TGtOpenAIWithAssistantChat,
	#instVars : [
		'assistantChat'
	],
	#category : #'Gt4OpenAI-Widgets'
}

{ #category : #accessing }
TGtOpenAIWithAssistantChat >> assistantChat [
	<return: #TGtOpenAIWithAssistantChat>
	^ assistantChat
]

{ #category : #accessing }
TGtOpenAIWithAssistantChat >> assistantChat: anObject [
	assistantChat = anObject ifTrue: [ ^ self ].
	assistantChat ifNotNil: [ self unsubscribeFromAssistantChat ].
	assistantChat := anObject.
	self onAssistantChatChanged.
	self subscribeToAssistantChat.
]

{ #category : #'private - hooks' }
TGtOpenAIWithAssistantChat >> onAssistantChatChanged [
]

{ #category : #'private - hooks' }
TGtOpenAIWithAssistantChat >> subscribeToAssistantChat [
]

{ #category : #'private - hooks' }
TGtOpenAIWithAssistantChat >> unsubscribeFromAssistantChat [
]
