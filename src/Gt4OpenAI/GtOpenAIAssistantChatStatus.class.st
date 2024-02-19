Class {
	#name : #GtOpenAIAssistantChatStatus,
	#superclass : #Object,
	#category : #'Gt4OpenAI-Chats'
}

{ #category : #factory }
GtOpenAIAssistantChatStatus class >> forAssistantChat: anAssistantChat [
	 
]

{ #category : #factory }
GtOpenAIAssistantChatStatus class >> forLastRun: aGtOpenAIThreadRun [
	aGtOpenAIThreadRun ifNil: [ ^ GtOpenAIAssistantChatReadyStatus default ].
	^ GtOpenAIAssistantChatDynamicStatus new threadRun: aGtOpenAIThreadRun
]
