Class {
	#name : #GtLlmNullProvider,
	#superclass : #Object,
	#instVars : [
		'chat'
	],
	#category : #'Gt4Llm-Chats'
}

{ #category : #accessing }
GtLlmNullProvider >> chat [
	^ chat
]

{ #category : #accessing }
GtLlmNullProvider >> chat: anObject [
	chat := anObject
]

{ #category : #'as yet unclassified' }
GtLlmNullProvider >> instructions: aString [
]

{ #category : #'as yet unclassified' }
GtLlmNullProvider >> sendMessage: aMessage [
	self chat addMessage: (GtLlmUserMessage new content: aMessage)
]

{ #category : #'as yet unclassified' }
GtLlmNullProvider >> status [
	^ GtLlmAssistantChatReadyStatus new
]
