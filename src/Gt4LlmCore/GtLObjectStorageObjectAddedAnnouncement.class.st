Class {
	#name : #GtLObjectStorageObjectAddedAnnouncement,
	#superclass : #GtLObjectStorageContentChangeAnnouncement,
	#instVars : [
		'storedObject'
	],
	#category : #'Gt4LlmCore-Object Storage'
}

{ #category : #accessing }
GtLObjectStorageObjectAddedAnnouncement >> storedObject [
	^storedObject
]

{ #category : #accessing }
GtLObjectStorageObjectAddedAnnouncement >> storedObject: anObject [
	storedObject := anObject
]
