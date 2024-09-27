Class {
	#name : #GtSharedStringUpdated,
	#superclass : #Announcement,
	#instVars : [
		'string'
	],
	#category : #'Gt4Llm-Announcements'
}

{ #category : #accessing }
GtSharedStringUpdated >> string [
	^ string
]

{ #category : #accessing }
GtSharedStringUpdated >> string: anObject [
	string := anObject
]
