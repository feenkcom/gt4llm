Class {
	#name : #Gt4OpenAINewThreadMessageContentsChanged,
	#superclass : #Announcement,
	#instVars : [
		'threadMessage',
		'contents',
		'requester'
	],
	#category : #'Gt4OpenAI-Announcements'
}

{ #category : #accessing }
Gt4OpenAINewThreadMessageContentsChanged >> contents [
	^ contents
]

{ #category : #accessing }
Gt4OpenAINewThreadMessageContentsChanged >> contents: anObject [
	contents := anObject
]

{ #category : #accessing }
Gt4OpenAINewThreadMessageContentsChanged >> requester [
	^ requester
]

{ #category : #accessing }
Gt4OpenAINewThreadMessageContentsChanged >> requester: anObject [
	requester := anObject
]

{ #category : #accessing }
Gt4OpenAINewThreadMessageContentsChanged >> threadMessage [
	^ threadMessage
]

{ #category : #accessing }
Gt4OpenAINewThreadMessageContentsChanged >> threadMessage: anObject [
	threadMessage := anObject
]
