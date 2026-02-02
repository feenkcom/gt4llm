Class {
	#name : #GtLChatViewModel,
	#superclass : #Object,
	#traits : 'TGtAnnouncer + TGtLWithChat',
	#classTraits : 'TGtAnnouncer classTrait + TGtLWithChat classTrait',
	#instVars : [
		'newMessageViewModel',
		'messageViewModelsCache',
		'announcer'
	],
	#category : #'Gt4LlmCore-UI - View Models'
}

{ #category : #announcer }
GtLChatViewModel >> announcer [
	^ announcer
]

{ #category : #accessing }
GtLChatViewModel >> assistantChat [
	<return: #GtLChat>
	self
		deprecated: 'Please use #chat instead.'
		transformWith: '`@receiver assistantChat' -> '`@receiver chat'.

	^ self chat
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
		chat: self chat;
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

{ #category : #'private - chat' }
GtLChatViewModel >> onChatChanged [
	newMessageViewModel chat: chat
]

{ #category : #'private - event handling' }
GtLChatViewModel >> onChatMessageAdded: anAnnouncement [
	anAnnouncement chat = self chat ifFalse: [ ^ self ].

	self notifyChatMessageAdded: anAnnouncement message
]

{ #category : #'api - communication' }
GtLChatViewModel >> sendMessage: aString [
	self assistantChat sendMessage: aString
]

{ #category : #'private - chat' }
GtLChatViewModel >> subscribeToChat [
	self chat announcer weak
		when: GtLChatMessageAdded
		send: #onChatMessageAdded:
		to: self
]

{ #category : #'private - chat' }
GtLChatViewModel >> unsubscribeFromChat [
	self chat announcer unsubscribe: self
]
