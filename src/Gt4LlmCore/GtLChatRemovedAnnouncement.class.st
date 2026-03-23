Class {
	#name : #GtLChatRemovedAnnouncement,
	#superclass : #GtLChatRegistryAnnouncement,
	#instVars : [
		'chat'
	],
	#category : #'Gt4LlmCore-Announcements'
}

{ #category : #accessing }
GtLChatRemovedAnnouncement >> chat [
	^ chat
]

{ #category : #accessing }
GtLChatRemovedAnnouncement >> chat: aChat [
	chat := aChat
]
