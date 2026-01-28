Class {
	#name : #GtLMessageViewModelExecutionStateChanged,
	#superclass : #GtLMessageViewModelAnnouncement,
	#instVars : [
		'executionState'
	],
	#category : #'Gt4LlmCore-Announcements'
}

{ #category : #accessing }
GtLMessageViewModelExecutionStateChanged >> executionState [
	^ executionState
]

{ #category : #accessing }
GtLMessageViewModelExecutionStateChanged >> executionState: anObject [
	executionState := anObject
]
