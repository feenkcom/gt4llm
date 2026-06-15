Class {
	#name : #GtLConnectionRegistryViewModelConnectionsChanged,
	#superclass : #GtLChatRegistryViewModelAnnouncement,
	#instVars : [
		'connections'
	],
	#category : #'Gt4LlmCore-Announcements'
}

{ #category : #accessing }
GtLConnectionRegistryViewModelConnectionsChanged >> connections [
	^ connections
]

{ #category : #accessing }
GtLConnectionRegistryViewModelConnectionsChanged >> connections: anObject [
	connections := anObject
]
