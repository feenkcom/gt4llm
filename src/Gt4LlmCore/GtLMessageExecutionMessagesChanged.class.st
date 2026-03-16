Class {
	#name : #GtLMessageExecutionMessagesChanged,
	#superclass : #GtLMessageAnnouncement,
	#instVars : [
		'addedExecutionMessages',
		'removedExecutionMessages'
	],
	#category : #'Gt4LlmCore-Announcements'
}

{ #category : #accessing }
GtLMessageExecutionMessagesChanged >> addedExecutionMessages [
	^ addedExecutionMessages
]

{ #category : #accessing }
GtLMessageExecutionMessagesChanged >> addedExecutionMessages: anObject [
	addedExecutionMessages := anObject
]

{ #category : #accessing }
GtLMessageExecutionMessagesChanged >> removedExecutionMessages [
	^ removedExecutionMessages
]

{ #category : #accessing }
GtLMessageExecutionMessagesChanged >> removedExecutionMessages: anObject [
	removedExecutionMessages := anObject
]
