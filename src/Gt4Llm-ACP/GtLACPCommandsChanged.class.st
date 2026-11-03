"
I announce a replacement of the available command snapshot without invalidating chat messages.
"
Class {
	#name : #GtLACPCommandsChanged,
	#superclass : #Announcement,
	#instVars : [
		'session'
	],
	#category : #'Gt4Llm-ACP-Announcements'
}

{ #category : #accessing }
GtLACPCommandsChanged >> session [
	^ session
]

{ #category : #accessing }
GtLACPCommandsChanged >> session: aSession [
	session := aSession
]
