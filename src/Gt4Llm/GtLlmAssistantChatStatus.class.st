Class {
	#name : #GtLlmAssistantChatStatus,
	#superclass : #Object,
	#category : #'Gt4Llm-Chats'
}

{ #category : #factory }
GtLlmAssistantChatStatus class >> forAssistantChat: anAssistantChat [
	 
]

{ #category : #factory }
GtLlmAssistantChatStatus class >> forLastRun: aGtOpenAIThreadRun [
	aGtOpenAIThreadRun ifNil: [ ^ GtLlmAssistantChatReadyStatus default ].
	^ GtLlmAssistantChatDynamicStatus new threadRun: aGtOpenAIThreadRun
]

{ #category : #accessing }
GtLlmAssistantChatStatus >> completedAt [
	<return: #DateAndTime or: nil>
	^ self subclassResponsibility
]

{ #category : #accessing }
GtLlmAssistantChatStatus >> createdAt [
	<return: #DateAndTime>
	^ self subclassResponsibility
]

{ #category : #testing }
GtLlmAssistantChatStatus >> isDone [
	^ self subclassResponsibility
]

{ #category : #testing }
GtLlmAssistantChatStatus >> isFailed [
	^ self subclassResponsibility
]
