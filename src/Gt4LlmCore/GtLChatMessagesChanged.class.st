Class {
	#name : #GtLChatMessagesChanged,
	#superclass : #GtLChatAnnouncement,
	#instVars : [
		'messages'
	],
	#category : #'Gt4LlmCore-Announcements'
}

{ #category : #accessing }
GtLChatMessagesChanged >> messages [
	^ messages
]

{ #category : #accessing }
GtLChatMessagesChanged >> messages: anObject [
	messages := anObject
]
