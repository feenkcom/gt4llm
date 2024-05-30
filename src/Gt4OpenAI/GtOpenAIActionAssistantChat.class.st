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
GtOpenAIActionAssistantChat >> onSendActionToChat: anAnnouncement [
	| action |
	action := self actions
			detect: [ :anAction | anAction name = anAnnouncement action ].

	self sendMessage: (action format format: anAnnouncement arguments)
]

{ #category : #accessing }
GtOpenAIActionAssistantChat >> pipeline: aPipeline [
	pipeline := aPipeline.
	pipeline chat: self.

	pipeline instance
		when: GtLlmSendActionToChat
		send: #onSendActionToChat:
		to: self
]

{ #category : #accessing }
GtOpenAIActionAssistantChat >> sendMessage: aString [
	^ super
		sendMessage: aString
				, '
	
state:
' , pipeline instance serialize
]
