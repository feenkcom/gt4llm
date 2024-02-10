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
	assistantChat := anObject.
	self onAssistantChatChanged
]

{ #category : #'private - hooks' }
TGt4OpenAIWithAssistantChat >> onAssistantChatChanged [
]
