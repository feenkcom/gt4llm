Class {
	#name : #GtLlmAssistantChatDynamicStatus,
	#superclass : #GtLlmAssistantChatStatus,
	#instVars : [
		'threadRun'
	],
	#category : #'Gt4Llm-Chats'
}

{ #category : #accessing }
GtLlmAssistantChatDynamicStatus >> completedAt [
	^ threadRun completedAt
]

{ #category : #accessing }
GtLlmAssistantChatDynamicStatus >> createdAt [
	^ threadRun createdAt
]

{ #category : #printing }
GtLlmAssistantChatDynamicStatus >> gtDisplayOn: stream [
	stream nextPutAll: threadRun status
]

{ #category : #testing }
GtLlmAssistantChatDynamicStatus >> isDone [
	^ threadRun isDone
]

{ #category : #testing }
GtLlmAssistantChatDynamicStatus >> isFailed [
	^ threadRun isFailed
]

{ #category : #accessing }
GtLlmAssistantChatDynamicStatus >> message [
	^ threadRun failureMessage
]

{ #category : #accessing }
GtLlmAssistantChatDynamicStatus >> threadRun [
	^ threadRun
]

{ #category : #accessing }
GtLlmAssistantChatDynamicStatus >> threadRun: anObject [
	threadRun := anObject
]
