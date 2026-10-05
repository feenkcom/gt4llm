Class {
	#name : #GtLMcpServerHistoryItemsRemovedAnnouncement,
	#superclass : #GtLMcpServerHistoryAnnouncement,
	#instVars : [
		'removedItems'
	],
	#category : #'Gt4LlmCore-Announcements'
}

{ #category : #accessing }
GtLMcpServerHistoryItemsRemovedAnnouncement >> removedItems [
	^ removedItems
]

{ #category : #accessing }
GtLMcpServerHistoryItemsRemovedAnnouncement >> removedItems: anObject [
	removedItems := anObject
]
