"
I announce a change to conversation ownership or displayed session and subagent metadata on an ACP connection. connection identifies the connection that announced the change.
"
Class {
	#name : #GtLACPConversationTreeChanged,
	#superclass : #Announcement,
	#instVars : [
		'connection'
	],
	#category : #'Gt4Llm-ACP-Announcements'
}

{ #category : #accessing }
GtLACPConversationTreeChanged >> connection [
	^ connection
]

{ #category : #accessing }
GtLACPConversationTreeChanged >> connection: anObject [
	connection := anObject
]
