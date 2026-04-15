Class {
	#name : #GtLChatViewModelMessageAdded,
	#superclass : #GtLChatViewModelMessagesChanged,
	#instVars : [
		'message'
	],
	#category : #'Gt4LlmCore-Announcements'
}

{ #category : #accessing }
GtLChatViewModelMessageAdded >> message [
	^ message
]

{ #category : #accessing }
GtLChatViewModelMessageAdded >> message: anObject [
	message := anObject
]
