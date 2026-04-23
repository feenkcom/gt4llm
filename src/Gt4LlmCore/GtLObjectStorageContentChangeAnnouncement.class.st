Class {
	#name : #GtLObjectStorageContentChangeAnnouncement,
	#superclass : #Announcement,
	#instVars : [
		'objectStorage'
	],
	#category : 'Gt4LlmCore-Object Storage'
}

{ #category : #accessing }
GtLObjectStorageContentChangeAnnouncement >> objectStorage [
	^objectStorage
]

{ #category : #accessing }
GtLObjectStorageContentChangeAnnouncement >> objectStorage: anObject [
	objectStorage := anObject
]
