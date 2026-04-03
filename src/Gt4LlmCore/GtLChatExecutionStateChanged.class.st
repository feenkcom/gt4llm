Class {
	#name : #GtLChatExecutionStateChanged,
	#superclass : #GtLChatAnnouncement,
	#instVars : [
		'state'
	],
	#category : #'Gt4LlmCore-Announcements'
}

{ #category : #accessing }
GtLChatExecutionStateChanged >> state [
	^ state
]

{ #category : #accessing }
GtLChatExecutionStateChanged >> state: anObject [
	state := anObject
]
