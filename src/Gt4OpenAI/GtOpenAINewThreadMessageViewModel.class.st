Class {
	#name : #GtOpenAINewThreadMessageViewModel,
	#superclass : #GtOpenAIBasicThreadMessageViewModel,
	#category : #'Gt4OpenAI-Widgets'
}

{ #category : #accessing }
GtOpenAINewThreadMessageViewModel >> contents [
	^ self threadMessage contents
]

{ #category : #accessing }
GtOpenAINewThreadMessageViewModel >> contents: aString requester: aRequester [
	self threadMessage contents: aString requester: aRequester
]

{ #category : #accessing }
GtOpenAINewThreadMessageViewModel >> elementClass [
	^ GtOpenAINewThreadMessageElement
]

{ #category : #actions }
GtOpenAINewThreadMessageViewModel >> sendMessage [
	^ threadMessage sendMessage
]
