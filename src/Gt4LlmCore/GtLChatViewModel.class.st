Class {
	#name : #GtLChatViewModel,
	#superclass : #Object,
	#traits : 'TGtAnnouncer',
	#classTraits : 'TGtAnnouncer classTrait',
	#instVars : [
		'chat',
		'newMessageViewModel',
		'messageViewModelsCache',
		'announcer'
	],
	#category : 'Gt4LlmCore-UI - View Models'
}

{ #category : #announcer }
GtLChatViewModel >> announcer [
	^ announcer
]

{ #category : #accessing }
GtLChatViewModel >> assistantChat [
	<return: #GtLChat>
	^ chat
]

{ #category : #accessing }
GtLChatViewModel >> assistantChat: aChat [
	chat = aChat ifTrue: [ ^ self ].
	chat ifNotNil: [ self unsubscribeFromAssistantChat ].
	chat := aChat.
	self onAssistantChatChanged.
	self subscribeToAssistantChat.
]

{ #category : #'api - initialization' }
GtLChatViewModel >> beSync [
	newMessageViewModel beSync
]

{ #category : #initialization }
GtLChatViewModel >> initialize [
	super initialize.
	announcer := Announcer new.
	messageViewModelsCache := Dictionary new.
	newMessageViewModel := GtLNewMessageViewModel new
]

{ #category : #'api - accessing' }
GtLChatViewModel >> messageViewModels [
	^ GtLChatMessageViewModelsBuilder new 
		chat: self assistantChat;
		cache: messageViewModelsCache;
		newMessageViewModel: newMessageViewModel;
		build
]

{ #category : #accessing }
GtLChatViewModel >> newMessageViewModel [
	^ newMessageViewModel
]

{ #category : #'private - event handling' }
GtLChatViewModel >> notifyChatMessageAdded: aMessage [
	self
		announce: (GtLChatViewModelMessageAdded new
				chatViewModel: self;
				message: aMessage)
]

{ #category : #'private - hooks' }
GtLChatViewModel >> onAssistantChatChanged [
	newMessageViewModel chat: chat
]

{ #category : #'private - event handling' }
GtLChatViewModel >> onChatMessageAdded: anAnnouncement [
	anAnnouncement chat = self assistantChat ifFalse: [ ^ self ].
	
	self notifyChatMessageAdded: anAnnouncement message
]

{ #category : #'api - communication' }
GtLChatViewModel >> sendMessage: aString [
	self assistantChat sendMessage: aString
]

{ #category : #'private - hooks' }
GtLChatViewModel >> subscribeToAssistantChat [
	self assistantChat announcer weak
		when: GtLChatMessageAdded
		send: #onChatMessageAdded:
		to: self
]

{ #category : #'private - hooks' }
GtLChatViewModel >> unsubscribeFromAssistantChat [
	self assistantChat announcer unsubscribe: self
]
