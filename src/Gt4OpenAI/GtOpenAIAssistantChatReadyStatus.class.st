Class {
	#name : #GtOpenAIAssistantChatReadyStatus,
	#superclass : #GtOpenAIAssistantChatStatus,
	#traits : 'TGtUniqueInstance',
	#classTraits : 'TGtUniqueInstance classTrait',
	#category : #'Gt4OpenAI-Chats'
}

{ #category : #accessing }
GtOpenAIAssistantChatReadyStatus >> completedAt [
	<return: #DateAndTime or: nil>
	^ DateAndTime now
]

{ #category : #accessing }
GtOpenAIAssistantChatReadyStatus >> createdAt [
	<return: #DateAndTime>
	^ DateAndTime now
]

{ #category : #printing }
GtOpenAIAssistantChatReadyStatus >> gtDisplayOn: stream [
	stream nextPutAll: 'Ready'
]

{ #category : #testing }
GtOpenAIAssistantChatReadyStatus >> isDone [
	^ true
]

{ #category : #testing }
GtOpenAIAssistantChatReadyStatus >> isFailed [
	^ false
]
