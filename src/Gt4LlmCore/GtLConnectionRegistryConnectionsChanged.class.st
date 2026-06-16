Class {
	#name : #GtLConnectionRegistryConnectionsChanged,
	#superclass : #GtLConnectionRegistryAnnouncement,
	#instVars : [
		'connections'
	],
	#category : #'Gt4LlmCore-Announcements'
}

{ #category : #accessing }
GtLConnectionRegistryConnectionsChanged >> connections [
	^ connections
]

{ #category : #accessing }
GtLConnectionRegistryConnectionsChanged >> connections: anObject [
	connections := anObject
]
