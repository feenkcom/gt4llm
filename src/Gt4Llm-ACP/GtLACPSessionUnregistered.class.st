"
I announce that a session was removed from a GtLACPSessionRegistry. Removing a session does not close it, so the session may still be running.
"
Class {
	#name : #GtLACPSessionUnregistered,
	#superclass : #GtLACPSessionRegistryAnnouncement,
	#instVars : [
		'session'
	],
	#category : #'Gt4Llm-ACP-Announcements'
}

{ #category : #accessing }
GtLACPSessionUnregistered >> session [
	^ session
]

{ #category : #accessing }
GtLACPSessionUnregistered >> session: aSession [
	session := aSession
]
