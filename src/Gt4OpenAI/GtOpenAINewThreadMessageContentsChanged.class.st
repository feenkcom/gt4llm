Class {
	#name : #GtOpenAINewThreadMessageContentsChanged,
	#superclass : #Announcement,
	#instVars : [
		'threadMessage',
		'contents',
		'requester'
	],
	#category : #'Gt4OpenAI-Announcements'
}

{ #category : #accessing }
GtOpenAINewThreadMessageContentsChanged >> contents [
	^ contents
]

{ #category : #accessing }
GtOpenAINewThreadMessageContentsChanged >> contents: anObject [
	contents := anObject
]

{ #category : #accessing }
GtOpenAINewThreadMessageContentsChanged >> requester [
	^ requester
]

{ #category : #accessing }
GtOpenAINewThreadMessageContentsChanged >> requester: anObject [
	requester := anObject
]

{ #category : #accessing }
GtOpenAINewThreadMessageContentsChanged >> threadMessage [
	^ threadMessage
]

{ #category : #accessing }
GtOpenAINewThreadMessageContentsChanged >> threadMessage: anObject [
	threadMessage := anObject
]
