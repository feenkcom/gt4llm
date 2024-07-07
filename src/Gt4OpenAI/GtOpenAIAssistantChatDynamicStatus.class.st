Class {
	#name : #GtOpenAIAssistantChatDynamicStatus,
	#superclass : #GtLlmAssistantChatStatus,
	#instVars : [
		'threadRun'
	],
	#category : #'Gt4OpenAI-Chats'
}

{ #category : #accessing }
GtOpenAIAssistantChatDynamicStatus >> completedAt [
	^ threadRun completedAt
]

{ #category : #accessing }
GtOpenAIAssistantChatDynamicStatus >> createdAt [
	^ threadRun createdAt
]

{ #category : #printing }
GtOpenAIAssistantChatDynamicStatus >> gtDisplayOn: stream [
	stream nextPutAll: threadRun status
]

{ #category : #testing }
GtOpenAIAssistantChatDynamicStatus >> isDone [
	^ threadRun isDone
]

{ #category : #testing }
GtOpenAIAssistantChatDynamicStatus >> isFailed [
	^ threadRun isFailed
]

{ #category : #accessing }
GtOpenAIAssistantChatDynamicStatus >> message [
	^ threadRun failureMessage
]

{ #category : #accessing }
GtOpenAIAssistantChatDynamicStatus >> threadRun [
	^ threadRun
]

{ #category : #accessing }
GtOpenAIAssistantChatDynamicStatus >> threadRun: anObject [
	threadRun := anObject
]
