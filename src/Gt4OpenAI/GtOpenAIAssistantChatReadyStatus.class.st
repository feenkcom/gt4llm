Class {
	#name : #GtOpenAIAssistantChatReadyStatus,
	#superclass : #GtOpenAIAssistantChatStatus,
	#traits : 'TGtUniqueInstance',
	#classTraits : 'TGtUniqueInstance classTrait',
	#category : #'Gt4OpenAI-Chats'
}

{ #category : #printing }
GtOpenAIAssistantChatReadyStatus >> gtDisplayOn: stream [
	stream nextPutAll: 'Ready'
]
