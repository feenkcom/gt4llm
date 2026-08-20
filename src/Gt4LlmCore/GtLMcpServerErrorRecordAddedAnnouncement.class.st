"
I am announced by GtLMcpServer (see #privateAddErrorRecord:) whenever a new GtLMcpServerErrorRecord is added to its errors collection. I mirror GtLMcpServerHistoryItemAddedAnnouncement.
"
Class {
	#name : #GtLMcpServerErrorRecordAddedAnnouncement,
	#superclass : #GtLMcpServerAnnouncement,
	#instVars : [
		'errorRecord'
	],
	#category : #'Gt4LlmCore-Announcements'
}

{ #category : #accessing }
GtLMcpServerErrorRecordAddedAnnouncement >> errorRecord [
	^ errorRecord
]

{ #category : #accessing }
GtLMcpServerErrorRecordAddedAnnouncement >> errorRecord: aGtLMcpServerErrorRecord [
	errorRecord := aGtLMcpServerErrorRecord
]
