Class {
	#name : #GtLMcpServerHistoryItemAddedAnnouncement,
	#superclass : #GtLMcpServerAnnouncement,
	#instVars : [
		'message'
	],
	#category : #'Gt4LlmCore-Announcements'
}

{ #category : #accessing }
GtLMcpServerHistoryItemAddedAnnouncement >> message [
	^ message
]

{ #category : #accessing }
GtLMcpServerHistoryItemAddedAnnouncement >> message: anObject [
	message := anObject
]
