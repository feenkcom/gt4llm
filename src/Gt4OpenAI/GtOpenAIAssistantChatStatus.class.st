Class {
	#name : #GtOpenAIAssistantChatStatus,
	#superclass : #Object,
	#category : #'Gt4OpenAI-Chats'
}

{ #category : #factory }
GtOpenAIAssistantChatStatus class >> forAssistantChat: anAssistantChat [
	 
]

{ #category : #factory }
GtOpenAIAssistantChatStatus class >> forLastRun: aGtOpenAIThreadRun [
	aGtOpenAIThreadRun ifNil: [ ^ GtOpenAIAssistantChatReadyStatus default ].
	^ GtOpenAIAssistantChatDynamicStatus new threadRun: aGtOpenAIThreadRun
]

{ #category : #accessing }
GtOpenAIAssistantChatStatus >> completedAt [
	<return: #DateAndTime or: nil>
	^ self subclassResponsibility
]

{ #category : #accessing }
GtOpenAIAssistantChatStatus >> createdAt [
	<return: #DateAndTime>
	^ self subclassResponsibility
]

{ #category : #testing }
GtOpenAIAssistantChatStatus >> isDone [
	^ self subclassResponsibility
]

{ #category : #testing }
GtOpenAIAssistantChatStatus >> isFailed [
	^ self subclassResponsibility
]
