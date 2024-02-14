Class {
	#name : #GtOpenAIThreadRunAnnouncement,
	#superclass : #Announcement,
	#instVars : [
		'run'
	],
	#category : #'Gt4OpenAI-Announcements'
}

{ #category : #accessing }
GtOpenAIThreadRunAnnouncement >> run [
	^ run
]

{ #category : #accessing }
GtOpenAIThreadRunAnnouncement >> run: anObject [
	run := anObject
]
