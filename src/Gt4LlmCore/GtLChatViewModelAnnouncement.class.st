Class {
	#name : #GtLChatViewModelAnnouncement,
	#superclass : #GtLAnnouncement,
	#instVars : [
		'chatViewModel'
	],
	#category : #'Gt4LlmCore-Announcements'
}

{ #category : #accessing }
GtLChatViewModelAnnouncement >> chatViewModel [
	^ chatViewModel
]

{ #category : #accessing }
GtLChatViewModelAnnouncement >> chatViewModel: anObject [
	chatViewModel := anObject
]
