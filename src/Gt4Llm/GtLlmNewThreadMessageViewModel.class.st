Class {
	#name : #GtLlmNewThreadMessageViewModel,
	#superclass : #GtLlmBasicThreadMessageViewModel,
	#category : #'Gt4Llm-Widgets'
}

{ #category : #actions }
GtLlmNewThreadMessageViewModel >> addMessageContents: aString [
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
GtLlmNewThreadMessageViewModel >> assistantChat: assistantChat [
	threadMessage assistantChat: assistantChat.

	assistantChat weak
		when: GtLlmAddMessageContentsRequest
		send: #onAddMessageContentsRequest:
		to: self
]

{ #category : #accessing }
GtLlmNewThreadMessageViewModel >> contents [
	^ self threadMessage contents
]

{ #category : #accessing }
GtLlmNewThreadMessageViewModel >> contents: aString requester: aRequester [
	self threadMessage contents: aString requester: aRequester
]

{ #category : #accessing }
GtLlmNewThreadMessageViewModel >> elementClass [
	^ GtLlmNewThreadMessageElement
]

{ #category : #accessing }
GtLlmNewThreadMessageViewModel >> messageActions [
	^ threadMessage messageActions
]

{ #category : #accessing }
GtLlmNewThreadMessageViewModel >> onAddMessageContentsRequest: anAnnouncement [
	self contents: anAnnouncement messageContents requester: nil
]

{ #category : #actions }
GtLlmNewThreadMessageViewModel >> sendMessage [
	^ threadMessage sendMessage
]
