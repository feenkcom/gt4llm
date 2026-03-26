Class {
	#name : #GtLChatMessageAdded,
	#superclass : #GtLChatMessagesChanged,
	#instVars : [
		'message'
	],
	#category : 'Gt4LlmCore-Announcements'
}

{ #category : #accessing }
GtLChatMessageAdded >> message [
	^ message
]

{ #category : #accessing }
GtLChatMessageAdded >> message: anObject [
	message := anObject
]
