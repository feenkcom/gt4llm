Class {
	#name : #GtOpenAIAssistantChatWorkingStatus,
	#superclass : #GtLlmAssistantChatStatus,
	#category : #'Gt4Ollama-Chat'
}

{ #category : #accessing }
GtOpenAIAssistantChatWorkingStatus >> completedAt [
	^ nil
]

{ #category : #accessing }
GtOpenAIAssistantChatWorkingStatus >> createdAt [
	^ DateAndTime now
]

{ #category : #accessing }
GtOpenAIAssistantChatWorkingStatus >> isDone [
	^ false
]

{ #category : #accessing }
GtOpenAIAssistantChatWorkingStatus >> isFailed [
	^ false
]
