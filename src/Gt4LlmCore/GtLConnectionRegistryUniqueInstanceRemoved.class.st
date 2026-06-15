Class {
	#name : #GtLConnectionRegistryUniqueInstanceRemoved,
	#superclass : #GtLConnectionRegistryAnnouncement,
	#instVars : [
		'newConnectionRegistry'
	],
	#category : #'Gt4LlmCore-Announcements'
}

{ #category : #accessing }
GtLConnectionRegistryUniqueInstanceRemoved >> newConnectionRegistry [
	^ newConnectionRegistry
]

{ #category : #accessing }
GtLConnectionRegistryUniqueInstanceRemoved >> newConnectionRegistry: anObject [
	newConnectionRegistry := anObject
]
