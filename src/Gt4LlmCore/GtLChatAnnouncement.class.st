Class {
	#name : #GtLChatAnnouncement,
	#superclass : #GtLAnnouncement,
	#instVars : [
		'chat'
	],
	#category : #'Gt4LlmCore-Announcements'
}

{ #category : #accessing }
GtLChatAnnouncement >> chat [
	^ chat
]

{ #category : #accessing }
GtLChatAnnouncement >> chat: anObject [
	chat := anObject
]
