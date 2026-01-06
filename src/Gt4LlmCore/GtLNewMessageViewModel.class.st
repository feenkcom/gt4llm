Class {
	#name : #GtLNewMessageViewModel,
	#superclass : #GtLBasicMessageViewModel,
	#instVars : [
		'connectionRegistry'
	],
	#category : #'Gt4LlmCore-UI - View Models'
}

{ #category : #visiting }
GtLNewMessageViewModel >> acceptVisitor: aVisitor [
	^ aVisitor visitNewMessageViewModel: self
]

{ #category : #'initialization ' }
GtLNewMessageViewModel >> assistantChat: assistantChat [
	self message assistantChat: assistantChat
]

{ #category : #'as yet unclassified' }
GtLNewMessageViewModel >> attachFile: aFileReference [
	self message addFile: aFileReference
]

{ #category : #'as yet unclassified' }
GtLNewMessageViewModel >> beSync [
	self message beSync
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
	^ self message contents
]

{ #category : #accessing }
GtLNewMessageViewModel >> contents: aString requester: aRequester [
	self message contents: aString requester: aRequester
]

{ #category : #'api - converting' }
GtLNewMessageViewModel >> elementClass [
	^ GtLNewMessageElement
]

{ #category : #'as yet unclassified' }
GtLNewMessageViewModel >> files [
	^ self message files
]

{ #category : #accessing }
GtLNewMessageViewModel >> onAddMessageContentsRequest: anAnnouncement [
	self contents: anAnnouncement messageContents requester: nil
]

{ #category : #'as yet unclassified' }
GtLNewMessageViewModel >> provider [
	^ self message assistantChat provider
]

{ #category : #'as yet unclassified' }
GtLNewMessageViewModel >> provider: aProvider [
	self message assistantChat provider: aProvider
]

{ #category : #actions }
GtLNewMessageViewModel >> sendMessage [
	^ self message sendMessage
]
