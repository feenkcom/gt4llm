Class {
	#name : #GtLMessageViewModelAnnouncement,
	#superclass : #GtLAnnouncement,
	#instVars : [
		'messageViewModel'
	],
	#category : #'Gt4LlmCore-Announcements'
}

{ #category : #accessing }
GtLMessageViewModelAnnouncement >> messageViewModel [
	^ messageViewModel
]

{ #category : #accessing }
GtLMessageViewModelAnnouncement >> messageViewModel: anObject [
	messageViewModel := anObject
]
