Class {
	#name : #GtLMessageViewModelAnnouncement,
	#superclass : #GtLAnnouncement,
	#instVars : [
		'messageViewModel',
		'source'
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

{ #category : #accessing }
GtLMessageViewModelAnnouncement >> source [
	^ source
]

{ #category : #accessing }
GtLMessageViewModelAnnouncement >> source: aSource [
	source := aSource
]
