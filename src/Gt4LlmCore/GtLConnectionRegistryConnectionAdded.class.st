Class {
	#name : #GtLConnectionRegistryConnectionAdded,
	#superclass : #GtLConnectionRegistryAnnouncement,
	#instVars : [
		'connection',
		'connections'
	],
	#category : #'Gt4LlmCore-Announcements'
}

{ #category : #accessing }
GtLConnectionRegistryConnectionAdded >> connection [
	^ connection
]

{ #category : #accessing }
GtLConnectionRegistryConnectionAdded >> connection: anObject [
	connection := anObject
]

{ #category : #accessing }
GtLConnectionRegistryConnectionAdded >> connections [
	^ connections
]

{ #category : #accessing }
GtLConnectionRegistryConnectionAdded >> connections: anObject [
	connections := anObject
]
