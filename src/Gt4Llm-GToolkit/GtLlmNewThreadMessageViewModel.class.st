Class {
	#name : #GtLlmNewThreadMessageViewModel,
	#superclass : #GtLlmBasicThreadMessageViewModel,
	#instVars : [
		'connectionRegistry'
	],
	#category : 'Gt4Llm-GToolkit-UI'
}

{ #category : #'initialization ' }
GtLlmNewThreadMessageViewModel >> assistantChat: assistantChat [
	threadMessage assistantChat: assistantChat
]

{ #category : #'as yet unclassified' }
GtLlmNewThreadMessageViewModel >> attachFile: aFileReference [
	self threadMessage addFile: aFileReference
]

{ #category : #'as yet unclassified' }
GtLlmNewThreadMessageViewModel >> beSync [
	threadMessage beSync
]

{ #category : #accessing }
GtLlmNewThreadMessageViewModel >> connectionRegistry [
	^ connectionRegistry
		ifNil: [ connectionRegistry := GtLlmConnectionRegistry uniqueInstance ]
]

{ #category : #accessing }
GtLlmNewThreadMessageViewModel >> connectionRegistry: anObject [
	connectionRegistry := anObject
]

{ #category : #'as yet unclassified' }
GtLlmNewThreadMessageViewModel >> connectionString [
	^ (self connectionRegistry connectionFor: self provider)
		ifNil: [ self provider modelName ]
		ifNotNil: #connectionString
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

{ #category : #'as yet unclassified' }
GtLlmNewThreadMessageViewModel >> files [
	^ self threadMessage files
]

{ #category : #accessing }
GtLlmNewThreadMessageViewModel >> onAddMessageContentsRequest: anAnnouncement [
	self contents: anAnnouncement messageContents requester: nil
]

{ #category : #'as yet unclassified' }
GtLlmNewThreadMessageViewModel >> provider [
	^ threadMessage assistantChat provider
]

{ #category : #'as yet unclassified' }
GtLlmNewThreadMessageViewModel >> provider: aProvider [
	self threadMessage assistantChat provider: aProvider
]

{ #category : #actions }
GtLlmNewThreadMessageViewModel >> sendMessage [
	^ threadMessage sendMessage
]
