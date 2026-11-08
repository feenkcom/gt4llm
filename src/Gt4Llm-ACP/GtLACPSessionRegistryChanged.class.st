"
I announce conversation changes on a registered connection, including state, messages and subagents. connection identifies the source connection and sessions contains the affected registered root sessions on that connection. A completed session startup identifies its session explicitly. Registration and removal use GtLACPSessionRegistered and GtLACPSessionUnregistered instead.
"
Class {
	#name : #GtLACPSessionRegistryChanged,
	#superclass : #GtLACPSessionRegistryAnnouncement,
	#instVars : [
		'connection',
		'sessions'
	],
	#category : #'Gt4Llm-ACP-Announcements'
}

{ #category : #accessing }
GtLACPSessionRegistryChanged >> connection [
	^ connection
]

{ #category : #accessing }
GtLACPSessionRegistryChanged >> connection: anObject [
	connection := anObject
]

{ #category : #accessing }
GtLACPSessionRegistryChanged >> sessions [
	^ sessions
]

{ #category : #accessing }
GtLACPSessionRegistryChanged >> sessions: anObject [
	sessions := anObject
]
