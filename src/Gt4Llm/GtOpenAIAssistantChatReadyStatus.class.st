Class {
	#name : #GtOpenAIAssistantChatReadyStatus,
	#superclass : #GtLlmAssistantChatStatus,
	#traits : 'TGtUniqueInstance',
	#classTraits : 'TGtUniqueInstance classTrait',
	#classInstVars : [
		'uniqueInstance'
	],
	#category : #'Gt4Llm-Chats'
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
