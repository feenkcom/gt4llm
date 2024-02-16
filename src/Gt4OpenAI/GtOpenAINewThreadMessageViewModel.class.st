Class {
	#name : #GtOpenAINewThreadMessageViewModel,
	#superclass : #GtOpenAIBasicThreadMessageViewModel,
	#category : #'Gt4OpenAI-Widgets'
}

{ #category : #actions }
GtOpenAINewThreadMessageViewModel >> addMessageContents: aString [
	| aNewContents anExistingContents |
	anExistingContents := self contents.
	aNewContents := String
			new: aString size + anExistingContents size + 1
			streamContents: [ :aStream | 
				aStream nextPutAll: anExistingContents.
				aStream cr.
				aStream nextPutAll: aString ].

	self contents: aNewContents requester: nil
]

{ #category : #'initialization ' }
GtOpenAINewThreadMessageViewModel >> assistantChat: assistantChat [
	threadMessage assistantChat: assistantChat
]

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
