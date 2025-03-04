Class {
	#name : #GtLlmNewThreadMessageViewModel,
	#superclass : #GtLlmBasicThreadMessageViewModel,
	#category : #'Gt4Llm-GToolkit'
}

{ #category : #'initialization ' }
GtLlmNewThreadMessageViewModel >> assistantChat: assistantChat [
	threadMessage assistantChat: assistantChat
]

{ #category : #'as yet unclassified' }
GtLlmNewThreadMessageViewModel >> attachFile: aFileReference [
	self threadMessage addFile: aFileReference
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
GtLlmNewThreadMessageViewModel >> onAddMessageContentsRequest: anAnnouncement [
	self contents: anAnnouncement messageContents requester: nil
]

{ #category : #actions }
GtLlmNewThreadMessageViewModel >> sendMessage [
	^ threadMessage sendMessage
]
