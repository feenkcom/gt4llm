Class {
	#name : #GtLNewThreadMessageViewModel,
	#superclass : #GtLBasicThreadMessageViewModel,
	#instVars : [
		'connectionRegistry'
	],
	#category : #'Gt4LlmCore-UI'
}

{ #category : #'initialization ' }
GtLNewThreadMessageViewModel >> assistantChat: assistantChat [
	threadMessage assistantChat: assistantChat
]

{ #category : #'as yet unclassified' }
GtLNewThreadMessageViewModel >> attachFile: aFileReference [
	self threadMessage addFile: aFileReference
]

{ #category : #'as yet unclassified' }
GtLNewThreadMessageViewModel >> beSync [
	threadMessage beSync
]

{ #category : #accessing }
GtLNewThreadMessageViewModel >> connectionRegistry [
	^ connectionRegistry
		ifNil: [ connectionRegistry := GtLConnectionRegistry uniqueInstance ]
]

{ #category : #accessing }
GtLNewThreadMessageViewModel >> connectionRegistry: anObject [
	connectionRegistry := anObject
]

{ #category : #'as yet unclassified' }
GtLNewThreadMessageViewModel >> connectionString [
	^ (self connectionRegistry connectionFor: self provider)
		ifNil: [ self provider modelName ]
		ifNotNil: #connectionString
]

{ #category : #accessing }
GtLNewThreadMessageViewModel >> contents [
	^ self threadMessage contents
]

{ #category : #accessing }
GtLNewThreadMessageViewModel >> contents: aString requester: aRequester [
	self threadMessage contents: aString requester: aRequester
]

{ #category : #accessing }
GtLNewThreadMessageViewModel >> elementClass [
	^ GtLNewThreadMessageElement
]

{ #category : #'as yet unclassified' }
GtLNewThreadMessageViewModel >> files [
	^ self threadMessage files
]

{ #category : #accessing }
GtLNewThreadMessageViewModel >> onAddMessageContentsRequest: anAnnouncement [
	self contents: anAnnouncement messageContents requester: nil
]

{ #category : #'as yet unclassified' }
GtLNewThreadMessageViewModel >> provider [
	^ threadMessage assistantChat provider
]

{ #category : #'as yet unclassified' }
GtLNewThreadMessageViewModel >> provider: aProvider [
	self threadMessage assistantChat provider: aProvider
]

{ #category : #actions }
GtLNewThreadMessageViewModel >> sendMessage [
	^ threadMessage sendMessage
]
