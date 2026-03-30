Class {
	#name : #GtLMessageExecutionStateChanged,
	#superclass : #GtLMessageAnnouncement,
	#instVars : [
		'executionState'
	],
	#category : 'Gt4LlmCore-Announcements'
}

{ #category : #accessing }
GtLMessageExecutionStateChanged >> executionState [
	^ executionState
]

{ #category : #accessing }
GtLMessageExecutionStateChanged >> executionState: anObject [
	executionState := anObject
]
