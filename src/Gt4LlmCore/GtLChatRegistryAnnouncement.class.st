Class {
	#name : #GtLChatRegistryAnnouncement,
	#superclass : #GtLAnnouncement,
	#instVars : [
		'registry'
	],
	#category : 'Gt4LlmCore-Announcements'
}

{ #category : #accessing }
GtLChatRegistryAnnouncement >> registry [
	^ registry
]

{ #category : #accessing }
GtLChatRegistryAnnouncement >> registry: anObject [
	registry := anObject
]
