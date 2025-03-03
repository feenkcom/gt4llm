Class {
	#name : #GtLlmAssistantChatNotReadyStatus,
	#superclass : #GtLlmAssistantChatStatus,
	#classInstVars : [
		'uniqueInstance'
	],
	#category : #Gt4Llm
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
