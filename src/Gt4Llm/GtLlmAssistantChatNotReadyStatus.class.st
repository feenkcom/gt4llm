Class {
	#name : #GtLlmAssistantChatNotReadyStatus,
	#superclass : #GtLlmAssistantChatStatus,
	#traits : 'TGtUniqueInstance',
	#classTraits : 'TGtUniqueInstance classTrait',
	#classInstVars : [
		'uniqueInstance'
	],
	#category : #'Gt4Llm-Chats'
}

{ #category : #accessing }
GtLlmAssistantChatNotReadyStatus >> completedAt [
	<return: #DateAndTime or: nil>
	^ nil
]

{ #category : #accessing }
GtLlmAssistantChatNotReadyStatus >> createdAt [
	<return: #DateAndTime>
	^ DateAndTime now
]

{ #category : #printing }
GtLlmAssistantChatNotReadyStatus >> gtDisplayOn: stream [
	stream nextPutAll: 'Ready'
]

{ #category : #testing }
GtLlmAssistantChatNotReadyStatus >> isDone [
	^ false
]

{ #category : #testing }
GtLlmAssistantChatNotReadyStatus >> isFailed [
	^ false
]
