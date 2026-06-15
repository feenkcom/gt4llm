Class {
	#name : #GtLConnectionRegistryAnnouncement,
	#superclass : #GtLAnnouncement,
	#instVars : [
		'connectionRegistry'
	],
	#category : #'Gt4LlmCore-Announcements'
}

{ #category : #accessing }
GtLConnectionRegistryAnnouncement >> connectionRegistry [
	^ connectionRegistry
]

{ #category : #accessing }
GtLConnectionRegistryAnnouncement >> connectionRegistry: anObject [
	connectionRegistry := anObject
]
