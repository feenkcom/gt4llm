Class {
	#name : #GtLChatRegistryViewModelRemovedAnnouncement,
	#superclass : #GtLChatRegistryViewModelAnnouncement,
	#instVars : [
		'chatViewModel'
	],
	#category : 'Gt4LlmCore-Announcements'
}

{ #category : #accessing }
GtLChatRegistryViewModelRemovedAnnouncement >> chatViewModel [
	^ chatViewModel
]

{ #category : #accessing }
GtLChatRegistryViewModelRemovedAnnouncement >> chatViewModel: anObject [
	chatViewModel := anObject
]
