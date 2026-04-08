Class {
	#name : #GtWorldElementChatRegistryAnnouncement,
	#superclass : #Announcement,
	#instVars : [
		'chatRegistry',
		'source',
		'worldElement'
	],
	#category : #'Gt4LlmCore-UI - Registry'
}

{ #category : #accessing }
GtWorldElementChatRegistryAnnouncement >> chatRegistry [
	^ chatRegistry
]

{ #category : #accessing }
GtWorldElementChatRegistryAnnouncement >> chatRegistry: anObject [
	chatRegistry := anObject
]

{ #category : #accessing }
GtWorldElementChatRegistryAnnouncement >> source [
	^ source
]

{ #category : #accessing }
GtWorldElementChatRegistryAnnouncement >> source: anObject [
	source := anObject
]

{ #category : #accessing }
GtWorldElementChatRegistryAnnouncement >> worldElement [
	^ worldElement
]

{ #category : #accessing }
GtWorldElementChatRegistryAnnouncement >> worldElement: anObject [
	worldElement := anObject
]
