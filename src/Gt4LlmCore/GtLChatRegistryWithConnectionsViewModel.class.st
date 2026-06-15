Class {
	#name : #GtLChatRegistryWithConnectionsViewModel,
	#superclass : #Object,
	#instVars : [
		'registryViewModel',
		'connectionRegistry',
		'selectedConnection',
		'selectedDescription'
	],
	#category : #'Gt4LlmCore-UI - View Models'
}

{ #category : #'as yet unclassified' }
GtLChatRegistryWithConnectionsViewModel >> addChat [
	| aProvider |
	aProvider := self selectedConnection buildProvider.
	^ self selectedDescription newChatWithProvider: aProvider
]

{ #category : #accessing }
GtLChatRegistryWithConnectionsViewModel >> announcer [
	^ self registryViewModel announcer
]

{ #category : #converting }
GtLChatRegistryWithConnectionsViewModel >> asChatRegistryWithConnectionsViewModel [
	^ self
]

{ #category : #accessing }
GtLChatRegistryWithConnectionsViewModel >> chatDescriptions [
	^ self registryViewModel chatDescriptions
]

{ #category : #accessing }
GtLChatRegistryWithConnectionsViewModel >> chatViewModels [
	^ self registryViewModel chatViewModels
]

{ #category : #accessing }
GtLChatRegistryWithConnectionsViewModel >> connectableConnections [
	<return: #Collection of: #GtLConnection>
	^ self connectionRegistry connectableConnections
]

{ #category : #accessing }
GtLChatRegistryWithConnectionsViewModel >> connectionRegistry [
	<return: #GtLConnectionRegistry>
	connectionRegistry
		ifNil: [ self connectionRegistry: GtLConnectionRegistry default ].
	^ connectionRegistry
]

{ #category : #'api - initialization' }
GtLChatRegistryWithConnectionsViewModel >> connectionRegistry: aConnectionRegistry [
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
			to: self
]

{ #category : #accessing }
GtLChatRegistryWithConnectionsViewModel >> defaultChatDescription [
	^ self registryViewModel defaultChatDescription
]

{ #category : #accessing }
GtLChatRegistryWithConnectionsViewModel >> defaultConnectionRegistry [
	<return: #GtLConnection>
	^ self connectionRegistry defaultConnection
]

{ #category : #testing }
GtLChatRegistryWithConnectionsViewModel >> hasConnectableDefaultConnection [
	^ self connectionRegistry hasConnectableDefaultConnection
]

{ #category : #'private - event handling' }
GtLChatRegistryWithConnectionsViewModel >> onGtLConnectionRegistryConnectionAdded: anAnnouncement [
	anAnnouncement connectionRegistry = connectionRegistry ifFalse: [ ^ self ].

	self announcer
		announce: (GtLConnectionRegistryViewModelConnectionAdded new
				registryViewModel: self;
				connections: anAnnouncement connections;
				connection: anAnnouncement connection)
]

{ #category : #'private - event handling' }
GtLChatRegistryWithConnectionsViewModel >> onGtLConnectionRegistryConnectionsChanged: anAnnouncement [
	anAnnouncement connectionRegistry = connectionRegistry ifFalse: [ ^ self ].

	self announcer
		announce: (GtLConnectionRegistryViewModelConnectionsChanged new
				registryViewModel: self;
				connections: anAnnouncement connections)
]

{ #category : #accessing }
GtLChatRegistryWithConnectionsViewModel >> registryViewModel [
	^ registryViewModel
]

{ #category : #accessing }
GtLChatRegistryWithConnectionsViewModel >> registryViewModel: anObject [
	registryViewModel := anObject.
	self connectionRegistry: GtLConnectionRegistry default
]

{ #category : #accessing }
GtLChatRegistryWithConnectionsViewModel >> selectedConnection [
	^ selectedConnection
		ifNil: [ selectedConnection := self defaultConnectionRegistry ]
]

{ #category : #accessing }
GtLChatRegistryWithConnectionsViewModel >> selectedConnection: aConnection source: aSource [
	selectedConnection := aConnection
]

{ #category : #accessing }
GtLChatRegistryWithConnectionsViewModel >> selectedDescription [
	^ selectedDescription
		ifNil: [ selectedDescription := self defaultChatDescription ]
]

{ #category : #accessing }
GtLChatRegistryWithConnectionsViewModel >> selectedDescription: aDescription source: aSource [
	selectedDescription := aDescription
]

{ #category : #actions }
GtLChatRegistryWithConnectionsViewModel >> updateConnections [

	connectionRegistry updateConnections
]
