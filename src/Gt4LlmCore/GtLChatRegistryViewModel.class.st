Class {
	#name : #GtLChatRegistryViewModel,
	#superclass : #Object,
	#traits : 'TGtLWithRegistry',
	#classTraits : 'TGtLWithRegistry classTrait',
	#instVars : [
		'chatViewModelsCache',
		'announcer',
		'connectionRegistry',
		'selectedConnection',
		'selectedDescription'
	],
	#category : #'Gt4LlmCore-UI - View Models'
}

{ #category : #actions }
GtLChatRegistryViewModel >> addChat [
	| aProvider |
	aProvider := self selectedConnection buildProvider.
	^ self selectedDescription newChatWithProvider: aProvider
]

{ #category : #accessing }
GtLChatRegistryViewModel >> announcer [
	^ announcer
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
GtLChatRegistryViewModel >> connectableConnections [
	<return: #Collection of: #GtLConnection>
	^ self connectionRegistry connectableConnections
]

{ #category : #accessing }
GtLChatRegistryViewModel >> connectionRegistry [
	<return: #GtLConnectionRegistry>
	connectionRegistry
		ifNil: [ self connectionRegistry: GtLConnectionRegistry default ].
	^ connectionRegistry
]

{ #category : #'api - initialization' }
GtLChatRegistryViewModel >> connectionRegistry: aConnectionRegistry [
	self assert: [ aConnectionRegistry isNotNil ].

	connectionRegistry = aConnectionRegistry ifTrue: [ ^ self ].

	connectionRegistry
		ifNotNil: [ :anOldConnectionRegistry | anOldConnectionRegistry announcer unsubscribe: self ].

	connectionRegistry := aConnectionRegistry.

	connectionRegistry announcer weak
		when: GtLConnectionRegistryConnectionsChanged
			send: #onGtLConnectionRegistryConnectionsChanged:
			to: self;
		when: GtLConnectionRegistryConnectionAdded
			send: #onGtLConnectionRegistryConnectionAdded:
			to: self;
		when: GtLConnectionRegistryUniqueInstanceRemoved
			send: #onGtLConnectionRegistryUniqueInstanceRemoved:
			to: self
]

{ #category : #accessing }
GtLChatRegistryViewModel >> defaultChatDescription [ 
	^ self registry defaultChatDescription
]

{ #category : #accessing }
GtLChatRegistryViewModel >> defaultConnectionRegistry [
	<return: #GtLConnection>
	^ self connectionRegistry defaultConnection
]

{ #category : #accessing }
GtLChatRegistryViewModel >> ensureChatViewModelFor: aChat [
	^ chatViewModelsCache at: aChat ifAbsentPut: [ aChat asViewModel ]
]

{ #category : #testing }
GtLChatRegistryViewModel >> hasConnectableDefaultConnection [
	^ self connectionRegistry hasConnectableDefaultConnection
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

{ #category : #'private - event handling' }
GtLChatRegistryViewModel >> onGtLConnectionRegistryConnectionAdded: anAnnouncement [
	anAnnouncement connectionRegistry = connectionRegistry ifFalse: [ ^ self ].

	self announcer
		announce: (GtLConnectionRegistryViewModelConnectionAdded new
				registryViewModel: self;
				connections: anAnnouncement connections;
				connection: anAnnouncement connection)
]

{ #category : #'private - event handling' }
GtLChatRegistryViewModel >> onGtLConnectionRegistryConnectionsChanged: anAnnouncement [
	anAnnouncement connectionRegistry = connectionRegistry ifFalse: [ ^ self ].

	self announcer
		announce: (GtLConnectionRegistryViewModelConnectionsChanged new
				registryViewModel: self;
				connections: anAnnouncement connections)
]

{ #category : #'private - event handling' }
GtLChatRegistryViewModel >> onGtLConnectionRegistryUniqueInstanceRemoved: anAnnouncement [
	anAnnouncement connectionRegistry = connectionRegistry ifFalse: [ ^ self ].

	self connectionRegistry: anAnnouncement newConnectionRegistry.

	self announcer
		announce: (GtLConnectionRegistryViewModelUniqueInstanceRemoved new registryViewModel: self)
]

{ #category : #accessing }
GtLChatRegistryViewModel >> selectedConnection [
	^ selectedConnection
		ifNil: [ selectedConnection := self defaultConnectionRegistry ]
]

{ #category : #accessing }
GtLChatRegistryViewModel >> selectedConnection: aConnection source: aSource [
	selectedConnection := aConnection
]

{ #category : #accessing }
GtLChatRegistryViewModel >> selectedDescription [
	^ selectedDescription
		ifNil: [ selectedDescription := self defaultChatDescription ]
]

{ #category : #accessing }
GtLChatRegistryViewModel >> selectedDescription: aDescription source: aSource [
	selectedDescription := aDescription
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

{ #category : #actions }
GtLChatRegistryViewModel >> updateConnections [

	connectionRegistry updateConnections
]
