Class {
	#name : #GtOpenAIAssistantChatDynamicStatus,
	#superclass : #GtOpenAIAssistantChatStatus,
	#instVars : [
		'threadRun'
	],
	#category : #'Gt4OpenAI-Chats'
}

{ #category : #printing }
GtOpenAIAssistantChatDynamicStatus >> gtDisplayOn: stream [
	stream nextPutAll: threadRun status
]

{ #category : #accessing }
GtOpenAIAssistantChatDynamicStatus >> threadRun [
	^ threadRun
]

{ #category : #accessing }
GtOpenAIAssistantChatDynamicStatus >> threadRun: anObject [
	threadRun := anObject
]
