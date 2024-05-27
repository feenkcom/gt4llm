Class {
	#name : #GtOpenAIActionAssistantChat,
	#superclass : #GtOpenAIAssistantChat,
	#instVars : [
		'actions'
	],
	#category : #'Gt4OpenAI-Chats'
}

{ #category : #accessing }
GtOpenAIActionAssistantChat >> actions [
	^ actions
]

{ #category : #accessing }
GtOpenAIActionAssistantChat >> actions: anObject [
	actions := anObject
]

{ #category : #accessing }
GtOpenAIActionAssistantChat >> asViewModel [
	^ GtLlmActionChatViewModel new assistantChat: self
]

{ #category : #accessing }
GtOpenAIActionAssistantChat >> sendMessage: aString [
	^ super
		sendMessage: aString
				, '
	
state:
' , pipeline instance serialize
]
