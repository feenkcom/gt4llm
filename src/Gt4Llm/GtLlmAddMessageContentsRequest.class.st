Class {
	#name : #GtLlmAddMessageContentsRequest,
	#superclass : #Announcement,
	#instVars : [
		'messageContents'
	],
	#category : #'Gt4Llm-Announcements'
}

{ #category : #accessing }
GtLlmAddMessageContentsRequest >> messageContents [
	<return: #String>
	^ messageContents
]

{ #category : #accessing }
GtLlmAddMessageContentsRequest >> messageContents: aString [
	messageContents := aString
]
