Class {
	#name : #GtLNewMessageViewModel,
	#superclass : #GtLBasicThreadMessageViewModel,
	#instVars : [
		'connectionRegistry'
	],
	#category : #'Gt4LlmCore-UI'
}

{ #category : #'initialization ' }
GtLNewMessageViewModel >> assistantChat: assistantChat [
	threadMessage assistantChat: assistantChat
]

{ #category : #'as yet unclassified' }
GtLNewMessageViewModel >> attachFile: aFileReference [
	self threadMessage addFile: aFileReference
]

{ #category : #'as yet unclassified' }
GtLNewMessageViewModel >> beSync [
	threadMessage beSync
]

{ #category : #accessing }
GtLNewMessageViewModel >> connectionRegistry [
	^ connectionRegistry
		ifNil: [ connectionRegistry := GtLConnectionRegistry uniqueInstance ]
]

{ #category : #accessing }
GtLNewMessageViewModel >> connectionRegistry: anObject [
	connectionRegistry := anObject
]

{ #category : #'as yet unclassified' }
GtLNewMessageViewModel >> connectionString [
	^ (self connectionRegistry connectionFor: self provider)
		ifNil: [ self provider modelName ]
		ifNotNil: #connectionString
]

{ #category : #accessing }
GtLNewMessageViewModel >> contents [
	^ self threadMessage contents
]

{ #category : #accessing }
GtLNewMessageViewModel >> contents: aString requester: aRequester [
	self threadMessage contents: aString requester: aRequester
]

{ #category : #accessing }
GtLNewMessageViewModel >> elementClass [
	^ GtLNewMessageElement
]

{ #category : #'as yet unclassified' }
GtLNewMessageViewModel >> files [
	^ self threadMessage files
]

{ #category : #accessing }
GtLNewMessageViewModel >> onAddMessageContentsRequest: anAnnouncement [
	self contents: anAnnouncement messageContents requester: nil
]

{ #category : #'as yet unclassified' }
GtLNewMessageViewModel >> provider [
	^ threadMessage assistantChat provider
]

{ #category : #'as yet unclassified' }
GtLNewMessageViewModel >> provider: aProvider [
	self threadMessage assistantChat provider: aProvider
]

{ #category : #actions }
GtLNewMessageViewModel >> sendMessage [
	^ threadMessage sendMessage
]
