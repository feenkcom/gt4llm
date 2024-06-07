Class {
	#name : #GtLlmSpawnRequestAnnouncement,
	#superclass : #Announcement,
	#instVars : [
		'object'
	],
	#category : #'Gt4OpenAI-Announcements'
}

{ #category : #accessing }
GtLlmSpawnRequestAnnouncement >> object [
	^ object
]

{ #category : #accessing }
GtLlmSpawnRequestAnnouncement >> object: anObject [
	object := anObject
]
