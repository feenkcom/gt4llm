Class {
	#name : #GtLChatViewModel,
	#superclass : #Object,
	#instVars : [
		'chat',
		'newMessageViewModel',
		'messageViewModelsCache'
	],
	#category : #'Gt4LlmCore-UI'
}

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
	messageViewModelsCache := Dictionary new.
	newMessageViewModel := GtLNewMessage new asViewModel
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

{ #category : #'private - hooks' }
GtLChatViewModel >> onAssistantChatChanged [
	newMessageViewModel assistantChat: chat
]

{ #category : #'api - communication' }
GtLChatViewModel >> sendMessage: aString [
	self assistantChat sendMessage: aString
]

{ #category : #'private - hooks' }
GtLChatViewModel >> subscribeToAssistantChat [
]

{ #category : #'private - hooks' }
GtLChatViewModel >> unsubscribeFromAssistantChat [
]
