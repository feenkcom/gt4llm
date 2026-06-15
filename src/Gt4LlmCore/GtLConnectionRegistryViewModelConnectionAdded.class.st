Class {
	#name : #GtLConnectionRegistryViewModelConnectionAdded,
	#superclass : #GtLChatRegistryViewModelAnnouncement,
	#instVars : [
		'connections',
		'connection'
	],
	#category : #'Gt4LlmCore-Announcements'
}

{ #category : #accessing }
GtLConnectionRegistryViewModelConnectionAdded >> connection [
	^ connection
]

{ #category : #accessing }
GtLConnectionRegistryViewModelConnectionAdded >> connection: anObject [
	connection := anObject
]

{ #category : #accessing }
GtLConnectionRegistryViewModelConnectionAdded >> connections [
	^ connections
]

{ #category : #accessing }
GtLConnectionRegistryViewModelConnectionAdded >> connections: anObject [
	connections := anObject
]
