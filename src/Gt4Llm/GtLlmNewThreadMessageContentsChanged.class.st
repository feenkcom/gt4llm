Class {
	#name : #GtLlmNewThreadMessageContentsChanged,
	#superclass : #Announcement,
	#instVars : [
		'threadMessage',
		'contents',
		'requester'
	],
	#category : #'Gt4Llm-Announcements'
}

{ #category : #accessing }
GtLlmNewThreadMessageContentsChanged >> contents [
	^ contents
]

{ #category : #accessing }
GtLlmNewThreadMessageContentsChanged >> contents: anObject [
	contents := anObject
]

{ #category : #accessing }
GtLlmNewThreadMessageContentsChanged >> requester [
	^ requester
]

{ #category : #accessing }
GtLlmNewThreadMessageContentsChanged >> requester: anObject [
	requester := anObject
]

{ #category : #accessing }
GtLlmNewThreadMessageContentsChanged >> threadMessage [
	^ threadMessage
]

{ #category : #accessing }
GtLlmNewThreadMessageContentsChanged >> threadMessage: anObject [
	threadMessage := anObject
]
