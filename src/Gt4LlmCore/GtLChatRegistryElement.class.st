Class {
	#name : #GtLChatRegistryElement,
	#superclass : #GtLChatRegistryBasicElement,
	#instVars : [
		'addNewChatElement',
		'listElement',
		'emptyConnectionsElement'
	],
	#category : #'Gt4LlmCore-UI - Registry'
}

{ #category : #initialization }
GtLChatRegistryElement >> defaultLayout [
	^ BlLinearLayout vertical
		alignTopLeft;
		cellSpacing: 0
]

{ #category : #initialization }
GtLChatRegistryElement >> initialize [
	super initialize.

	self initializeListElement.
	self initializeAddNewChatElement.
	self initializeEmptyConnectionsElement.

	self
		addChild: ((self newLabelWithText: 'Chats')
				padding: (BlInsets
						top: 10
						left: 10
						bottom: 5
						right: 10))
		as: #header.
	self addChild: listElement.
	self addChild: addNewChatElement.
	self addChild: emptyConnectionsElement.

	self addAptitude: (BrLayoutResizerAptitude new common: listElement).

	self matchParent
]

{ #category : #initialization }
GtLChatRegistryElement >> initializeAddNewChatElement [
	addNewChatElement := GtLChatRegistryAddNewChatElement new
			hMatchParent;
			padding: (BlInsets top: 3 left: 0 bottom: 3 right: 0)
]

{ #category : #initialization }
GtLChatRegistryElement >> initializeEmptyConnectionsElement [
	emptyConnectionsElement := GtLChatRegistryEmptyConnectionsElement new
			visibility: BlVisibility gone
]

{ #category : #initialization }
GtLChatRegistryElement >> initializeListElement [
	listElement := GtLChatRegistryListElement new
]

{ #category : #'private - instance creation' }
GtLChatRegistryElement >> newLabelWithText: aString [
	^ BrLabel new
		aptitude: (BrGlamorousLabelAptitude new bold ; fontSize: 18);
		text: aString
]

{ #category : #'private - hooks' }
GtLChatRegistryElement >> onGtLConnectionRegistryViewModelConnectionAdded: anAnnouncement [
	anAnnouncement registryViewModel = self registryViewModel ifFalse: [ ^ self ].
	self registryViewModel ifNil: [ ^ self ].

	BlTaskAction enqueueElement: self action: [ self updateElement ]
]

{ #category : #'private - hooks' }
GtLChatRegistryElement >> onGtLConnectionRegistryViewModelConnectionsChanged: anAnnouncement [
	anAnnouncement registryViewModel = self registryViewModel ifFalse: [ ^ self ].
	self registryViewModel ifNil: [ ^ self ].

	BlTaskAction enqueueElement: self action: [ self updateElement ]
]

{ #category : #'private - hooks' }
GtLChatRegistryElement >> onGtLConnectionRegistryViewModelUniqueInstanceRemoved: anAnnouncement [
	anAnnouncement registryViewModel = self registryViewModel ifFalse: [ ^ self ].
	self registryViewModel ifNil: [ ^ self ].
	
	BlTaskAction enqueueElement: self action: [ self updateConnectionsAndElement ]
]

{ #category : #updating }
GtLChatRegistryElement >> onRegistryViewModelChanged [
	super onRegistryViewModelChanged.

	listElement registryViewModel: self registryViewModel.
	addNewChatElement registryViewModel: self registryViewModel.
	emptyConnectionsElement registryViewModel: self registryViewModel.
	
	self updateElement
]

{ #category : #accessing }
GtLChatRegistryElement >> registryViewModel: anObject [
	super registryViewModel: anObject
]

{ #category : #'private - hooks' }
GtLChatRegistryElement >> subscribeToRegistryViewModel [
	super subscribeToRegistryViewModel.

	self registryViewModel announcer weak
		when: GtLConnectionRegistryViewModelConnectionsChanged
			send: #onGtLConnectionRegistryViewModelConnectionsChanged:
			to: self;
		when: GtLConnectionRegistryViewModelConnectionAdded
			send: #onGtLConnectionRegistryViewModelConnectionAdded:
			to: self;
		when: GtLConnectionRegistryViewModelUniqueInstanceRemoved
			send: #onGtLConnectionRegistryViewModelUniqueInstanceRemoved:
			to: self
]

{ #category : #'private - hooks' }
GtLChatRegistryElement >> unsubscribeFromRegistryViewModel [
	super unsubscribeFromRegistryViewModel.

	self registryViewModel announcer unsubscribe: self
]

{ #category : #'private - updating' }
GtLChatRegistryElement >> updateConnectionsAndElement [
	self registryViewModel updateConnections.
	self updateElement
]

{ #category : #'private - updating' }
GtLChatRegistryElement >> updateElement [
	(self registryViewModel hasConnectableDefaultConnection
		or: [ self registryViewModel chatViewModels isNotEmpty ])
		ifTrue: [ emptyConnectionsElement visibility: BlVisibility gone.
			listElement visibility: BlVisibility visible.
			addNewChatElement visibility: BlVisibility visible ]
		ifFalse: [ listElement visibility: BlVisibility gone.
			addNewChatElement visibility: BlVisibility gone.
			emptyConnectionsElement visibility: BlVisibility visible ]
]

{ #category : #'api - initialization' }
GtLChatRegistryElement >> withDeselectionOnSpawnEvents [
	listElement withDeselectionOnSpawnEvents
]

{ #category : #'api - initialization' }
GtLChatRegistryElement >> withoutChatsHeader [
	self
		childWithId: #header
		ifFound: [ :anElement | anElement visibility: BlVisibility gone ]
		ifNone: [  ]
]
