Class {
	#name : #GtLlmAssistantChatWorkingStatus,
	#superclass : #GtLlmAssistantChatStatus,
	#category : #'Gt4Llm-Chats'
}

{ #category : #accessing }
GtLlmAssistantChatWorkingStatus >> completedAt [
	^ nil
]

{ #category : #accessing }
GtLlmAssistantChatWorkingStatus >> createdAt [
	^ DateAndTime now
]

{ #category : #accessing }
GtLlmAssistantChatWorkingStatus >> isDone [
	^ false
]

{ #category : #accessing }
GtLlmAssistantChatWorkingStatus >> isFailed [
	^ false
]
