Class {
	#name : #GtLChatRegistryViewModelAnnouncement,
	#superclass : #GtLAnnouncement,
	#instVars : [
		'registryViewModel'
	],
	#category : #'Gt4LlmCore-Announcements'
}

{ #category : #accessing }
GtLChatRegistryViewModelAnnouncement >> registryViewModel [
	^ registryViewModel
]

{ #category : #accessing }
GtLChatRegistryViewModelAnnouncement >> registryViewModel: anObject [
	registryViewModel := anObject
]
