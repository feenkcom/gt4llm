Class {
	#name : #GtLlmAssistantChatReadyStatus,
	#superclass : #GtLlmAssistantChatStatus,
	#traits : 'TGtUniqueInstance',
	#classTraits : 'TGtUniqueInstance classTrait',
	#classInstVars : [
		'uniqueInstance'
	],
	#category : #Gt4Llm
}

{ #category : #accessing }
GtLlmAssistantChatReadyStatus >> completedAt [
	<return: #DateAndTime or: nil>
	^ DateAndTime now
]

{ #category : #accessing }
GtLlmAssistantChatReadyStatus >> createdAt [
	<return: #DateAndTime>
	^ DateAndTime now
]

{ #category : #printing }
GtLlmAssistantChatReadyStatus >> gtDisplayOn: stream [
	stream nextPutAll: 'Ready'
]

{ #category : #testing }
GtLlmAssistantChatReadyStatus >> isDone [
	^ true
]

{ #category : #testing }
GtLlmAssistantChatReadyStatus >> isFailed [
	^ false
]
