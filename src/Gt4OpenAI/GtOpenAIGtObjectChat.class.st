Class {
	#name : #GtOpenAIGtObjectChat,
	#superclass : #Object,
	#instVars : [
		'instance',
		'chat'
	],
	#category : #'Gt4OpenAI-Tutor'
}

{ #category : #accessing }
GtOpenAIGtObjectChat >> buildElement [
	| tutor |
	tutor := GtOpenAIViewActionTutor instance.
	tutor hasAssistant ifFalse: [ tutor createAssistant ].

	chat := tutor addChat.
	
	chat object: self instance.

	chat sendMessage: self initialMessage.

	^ GtLlmChatElement new
		assistantChatViewModel: (GtLlmChatViewModel new assistantChat: chat)
]

{ #category : #accessing }
GtOpenAIGtObjectChat >> chat [
	^ chat
]

{ #category : #accessing }
GtOpenAIGtObjectChat >> initialMessage [
	^ 'Generate a Phlow view'
]

{ #category : #accessing }
GtOpenAIGtObjectChat >> instance [
	^ instance
]

{ #category : #accessing }
GtOpenAIGtObjectChat >> instance: anObject [
	instance := anObject
]
