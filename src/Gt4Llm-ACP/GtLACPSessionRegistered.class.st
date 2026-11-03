"
I announce that a session was added to a GtLACPSessionRegistry.
"
Class {
	#name : #GtLACPSessionRegistered,
	#superclass : #GtLACPSessionRegistryAnnouncement,
	#instVars : [
		'session'
	],
	#category : #'Gt4Llm-ACP-Announcements'
}

{ #category : #accessing }
GtLACPSessionRegistered >> session [
	^ session
]

{ #category : #accessing }
GtLACPSessionRegistered >> session: aSession [
	session := aSession
]
