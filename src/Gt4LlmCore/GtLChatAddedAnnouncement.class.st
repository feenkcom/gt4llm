Class {
	#name : #GtLChatAddedAnnouncement,
	#superclass : #GtLChatRegistryAnnouncement,
	#instVars : [
		'chat'
	],
	#category : #'Gt4LlmCore-Announcements'
}

{ #category : #accessing }
GtLChatAddedAnnouncement >> chat [
	^ chat
]

{ #category : #accessing }
GtLChatAddedAnnouncement >> chat: aChat [
	chat := aChat
]
