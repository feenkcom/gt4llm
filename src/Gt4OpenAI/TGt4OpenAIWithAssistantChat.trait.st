Trait {
	#name : #TGt4OpenAIWithAssistantChat,
	#instVars : [
		'assistantChat'
	],
	#category : #'Gt4OpenAI-Widgets'
}

{ #category : #accessing }
TGt4OpenAIWithAssistantChat >> assistantChat [
	<return: #TGt4OpenAIWithAssistantChat>
	^ assistantChat
]

{ #category : #accessing }
TGt4OpenAIWithAssistantChat >> assistantChat: anObject [
	assistantChat = anObject ifTrue: [ ^ self ].
	assistantChat ifNotNil: [ self unsubscribeFromAssistantChat ].
	assistantChat := anObject.
	self onAssistantChatChanged.
	self subscribeToAssistantChat.
]

{ #category : #'private - hooks' }
TGt4OpenAIWithAssistantChat >> onAssistantChatChanged [
]

{ #category : #'private - hooks' }
TGt4OpenAIWithAssistantChat >> subscribeToAssistantChat [
]

{ #category : #'private - hooks' }
TGt4OpenAIWithAssistantChat >> unsubscribeFromAssistantChat [
]
