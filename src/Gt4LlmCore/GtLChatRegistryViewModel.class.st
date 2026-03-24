Class {
	#name : #GtLChatRegistryViewModel,
	#superclass : #Object,
	#traits : 'TGtLWithRegistry',
	#classTraits : 'TGtLWithRegistry classTrait',
	#instVars : [
		'chatViewModelsCache',
		'announcer'
	],
	#category : #'Gt4LlmCore-UI - View Models'
}

{ #category : #accessing }
GtLChatRegistryViewModel >> announcer [
	^ announcer
]

{ #category : #converting }
GtLChatRegistryViewModel >> asChatRegistryWithConnectionsViewModel [
	^ GtLChatRegistryWithConnectionsViewModel new registryViewModel: self
]

{ #category : #accessing }
GtLChatRegistryViewModel >> chatDescriptions [
	^ self registry descriptions
]

{ #category : #accessing }
GtLChatRegistryViewModel >> chatViewModels [
	^ self registry chats
		collect: [ :eachChat | self ensureChatViewModelFor: eachChat ]
]

{ #category : #accessing }
GtLChatRegistryViewModel >> defaultChatDescription [ 
	^ self registry defaultChatDescription
]

{ #category : #accessing }
GtLChatRegistryViewModel >> ensureChatViewModelFor: aChat [
	^ chatViewModelsCache at: aChat ifAbsentPut: [ aChat asViewModel ]
]

{ #category : #initialization }
GtLChatRegistryViewModel >> initialize [
	super initialize.
	announcer := Announcer new.

	chatViewModelsCache := AsyncSharedDictionary new
]

{ #category : #'private - hooks' }
GtLChatRegistryViewModel >> onChatAddedAnnouncement: anAnouncement [
	| aChatViewModel |
	self registry = anAnouncement registry ifFalse: [ ^ self ].

	aChatViewModel := self ensureChatViewModelFor: anAnouncement chat.

	self announcer
		announce: (GtLChatRegistryViewModelAddedAnnouncement new
				registryViewModel: self;
				chatViewModel: aChatViewModel)
]

{ #category : #'private - hooks' }
GtLChatRegistryViewModel >> onChatRemovedAnnouncement: anAnouncement [
	| aChatViewModel |
	self registry = anAnouncement registry ifFalse: [ ^ self ].

	aChatViewModel := chatViewModelsCache
			removeKey: anAnouncement chat
			ifAbsent: [ ^ self ].

	self announcer
		announce: (GtLChatRegistryViewModelRemovedAnnouncement new
				registryViewModel: self;
				chatViewModel: aChatViewModel)
]

{ #category : #'private - hooks' }
GtLChatRegistryViewModel >> subscribeToRegistry [
	self registry announcer weak
		when: GtLChatRemovedAnnouncement
			send: #onChatRemovedAnnouncement:
			to: self;
		when: GtLChatAddedAnnouncement
			send: #onChatAddedAnnouncement:
			to: self
]

{ #category : #'private - hooks' }
GtLChatRegistryViewModel >> unsubscribeFromRegistry [
	self registry announcer unsubscribe: self
]
