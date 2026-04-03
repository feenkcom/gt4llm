Class {
	#name : #GtLMessageAnnouncement,
	#superclass : #GtLAnnouncement,
	#instVars : [
		'message'
	],
	#category : #'Gt4LlmCore-Announcements'
}

{ #category : #accessing }
GtLMessageAnnouncement >> message [
	^ message
]

{ #category : #accessing }
GtLMessageAnnouncement >> message: anObject [
	message := anObject
]
