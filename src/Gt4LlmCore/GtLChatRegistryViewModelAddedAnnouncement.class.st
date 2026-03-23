Class {
	#name : #GtLChatRegistryViewModelAddedAnnouncement,
	#superclass : #GtLChatRegistryViewModelAnnouncement,
	#instVars : [
		'chatViewModel'
	],
	#category : #'Gt4LlmCore-Announcements'
}

{ #category : #accessing }
GtLChatRegistryViewModelAddedAnnouncement >> chatViewModel [
	^ chatViewModel
]

{ #category : #accessing }
GtLChatRegistryViewModelAddedAnnouncement >> chatViewModel: anObject [
	chatViewModel := anObject
]
