Class {
	#name : #GtLChatRegistryAddNewChatElement,
	#superclass : #GtLChatRegistryBasicElement,
	#instVars : [
		'connectionElement',
		'chatsElement',
		'addChatElement',
		'updateConnectionsElement'
	],
	#category : #'Gt4LlmCore-UI - Registry'
}

{ #category : #initialization }
GtLChatRegistryAddNewChatElement >> chatDescriptionLabel [
	^ self registryViewModel
		ifNotNil: [ :aViewModel | aViewModel selectedDescription ifNotNil: #label ifNil: [ 'Chat' ] ]
		ifNil: [ 'Chat' ]
]

{ #category : #initialization }
GtLChatRegistryAddNewChatElement >> connectionLabel [
	^ self registryViewModel
		ifNotNil: [ :aViewModel | aViewModel selectedConnection ifNotNil: #label ifNil: [ 'Connection' ] ]
		ifNil: [ 'Connection' ]
]

{ #category : #initialization }
GtLChatRegistryAddNewChatElement >> defaultLayout [
	^ BlLinearLayout horizontal
		alignCenterLeft;
		cellSpacing: 5
]

{ #category : #'private - accessing' }
GtLChatRegistryAddNewChatElement >> groupedConnections [

	^ self registryViewModel connectableConnections groupedBy: [ :connection |
		connection providerClass providerName ]
]

{ #category : #initialization }
GtLChatRegistryAddNewChatElement >> initialize [
	super initialize.

	self initializeChatDescriptionsElement.
	self initializeConnectionElement.
	self initializeAddChatElement.
	self initializeUpdateConnectionsElement.

	self addChild: chatsElement.
	self addChild: (self newLabelWithText: 'with').
	self addChild: connectionElement.
	self addChild: addChatElement.
	self addChild: updateConnectionsElement.

	self fitContent
]

{ #category : #initialization }
GtLChatRegistryAddNewChatElement >> initializeAddChatElement [
	addChatElement := BrButton new
			aptitude: BrGlamorousButtonWithIconAptitude;
			icon: BrGlamorousVectorIcons add;
			label: 'Add chat';
			action: [ :aButtonElement :aButtonModel :anEvent | self onAddChat: anEvent ]
]

{ #category : #initialization }
GtLChatRegistryAddNewChatElement >> initializeChatDescriptionsElement [
	chatsElement := (BrButton new
			aptitude: BrGlamorousButtonRectangularAptitude;
			addAptitude: (BrGlamorousButtonExteriorAptitude new
					backgroundPaint: self theme default backdropBackground);
			addAptitude: BrGlamorousButtonLabelAptitude;
			addAptitude: BrGlamorousButtonIconDropdownAptitude;
			label: self chatDescriptionLabel)
			addAptitude: (BrGlamorousWithExplicitDropdownAptitude new
					handle: [ BrButton new
							aptitude: BrGlamorousButtonWithLabelAptitude - BrGlamorousButtonExteriorAptitude;
							addAptitude: BrGlamorousButtonIconDropdownAptitude;
							label: self chatDescriptionLabel ]
					menu: [ self newChatDescriptionsMenuModel ])
]

{ #category : #initialization }
GtLChatRegistryAddNewChatElement >> initializeConnectionElement [
	connectionElement := (BrButton new
			aptitude: BrGlamorousButtonRectangularAptitude;
			addAptitude: (BrGlamorousButtonExteriorAptitude new
					backgroundPaint: self theme default backdropBackground);
			addAptitude: BrGlamorousButtonLabelAptitude;
			addAptitude: BrGlamorousButtonIconDropdownAptitude;
			label: self connectionLabel)
			addAptitude: (BrGlamorousWithExplicitDropdownAptitude new
					handle: [ (BrButton new
							aptitude: BrGlamorousButtonWithLabelAptitude - BrGlamorousButtonExteriorAptitude;
							addAptitude: BrGlamorousButtonIconDropdownAptitude;
							label: self connectionLabel)
							removeAptitude: BrGlamorousButtonExteriorAptitude ]
					menu: [ self newAvailableConnectionsMenuModel ])
]

{ #category : #initialization }
GtLChatRegistryAddNewChatElement >> initializeUpdateConnectionsElement [
	updateConnectionsElement := BrButton new
			aptitude: BrGlamorousButtonWithIconAptitude;
			icon: BrGlamorousVectorIcons refresh;
			label: 'Update Connections';
			action: [ :aButtonElement :aButtonModel :anEvent | self updateConnectionsFrom: anEvent ]
]

{ #category : #'private - menu models' }
GtLChatRegistryAddNewChatElement >> newAvailableConnectionsMenuModel [
	| groupedConnections aMenuItems |
	groupedConnections := self groupedConnections.
	groupedConnections ifEmpty: [ ^ nil ].

	aMenuItems := BrMenuItems new.
	aMenuItems beGroupedElementType.
	(groupedConnections associations
		asSortedCollection: [ :a :b | a key <= b key ])
		doWithIndex: [ :eachAssociation :index |
			| aGroupName someConnections |
			aGroupName := eachAssociation key.
			someConnections := eachAssociation value.
			someConnections
				do: [ :eachConnection |
					| anItem |
					anItem := BrMenuActionItem new
						label: [ eachConnection label ];
						groupId: aGroupName asSymbol priority: index;
						action: [ :anElement :aButtonModel :anEvent |
							self onSelectConnection: eachConnection ].
					aMenuItems addItem: anItem ] ].

	^ aMenuItems
]

{ #category : #initialization }
GtLChatRegistryAddNewChatElement >> newChatDescriptionsMenuModel [
	| someDescriptions aMenuItems |
	someDescriptions := self registryViewModel chatDescriptions.
	someDescriptions ifEmpty: [ ^ nil ].

	aMenuItems := BrMenuItems new.
	someDescriptions
		do: [ :eachDescription | 
			| anItem |
			anItem := BrMenuActionItem new
					label: [ eachDescription label ];
					action: [ :anElement :aButtonModel :anEvent | 
						self onSelectDescription: eachDescription ];
					definition: [ eachDescription definingMethod ].
			aMenuItems addItem: anItem ].

	^ aMenuItems
]

{ #category : #initialization }
GtLChatRegistryAddNewChatElement >> newConnectionBasicElement [
	^ BrButton new
		aptitude: BrGlamorousButtonWithLabelAptitude;
		addAptitude: BrGlamorousButtonIconDropdownAptitude;
		label: self connectionLabel
]

{ #category : #initialization }
GtLChatRegistryAddNewChatElement >> newLabelWithText: aString [
	^ BrLabel new
		aptitude: BrGlamorousLabelAptitude new;
		text: aString
]

{ #category : #'private - event handling' }
GtLChatRegistryAddNewChatElement >> onAddChat: anEvent [ 
	| aChat |
	self registryViewModel ifNil: [ ^ self ].
	
	aChat := self registryViewModel addChat.
	self phlow spawnObject: aChat
]

{ #category : #'private - hooks' }
GtLChatRegistryAddNewChatElement >> onGtLConnectionRegistryViewModelConnectionAdded: anAnnouncement [
	anAnnouncement registryViewModel = self registryViewModel ifFalse: [ ^ self ].

	BlTaskAction enqueueElement: self action: [ self updateConnectionElement ]
]

{ #category : #'private - hooks' }
GtLChatRegistryAddNewChatElement >> onGtLConnectionRegistryViewModelConnectionsChanged: anAnnouncement [
	anAnnouncement registryViewModel = self registryViewModel ifFalse: [ ^ self ].

	BlTaskAction enqueueElement: self action: [ 
		self updateConnectionElement ]
]

{ #category : #'private - hooks' }
GtLChatRegistryAddNewChatElement >> onGtLConnectionRegistryViewModelUniqueInstanceRemoved: anAnnouncement [
	anAnnouncement registryViewModel = self registryViewModel ifFalse: [ ^ self ].

	BlTaskAction enqueueElement: self action: [ self updateConnectionElement ]
]

{ #category : #'private - hooks' }
GtLChatRegistryAddNewChatElement >> onRegistryViewModelChanged [
	super onRegistryViewModelChanged.
	
	self updateElement
]

{ #category : #'private - event handling' }
GtLChatRegistryAddNewChatElement >> onSelectConnection: aConnection [
	self registryViewModel selectedConnection: aConnection source: self.
	
	BlTaskAction enqueueElement: self action: [ self updateConnectionElement ]
]

{ #category : #'private - event handling' }
GtLChatRegistryAddNewChatElement >> onSelectDescription: aDescription [
	self registryViewModel selectedDescription: aDescription source: self.
	
	BlTaskAction enqueueElement: self action: [ self updateDescriptionElement ]
]

{ #category : #accessing }
GtLChatRegistryAddNewChatElement >> registryViewModel: anObject [
	super registryViewModel: anObject
]

{ #category : #'private - hooks' }
GtLChatRegistryAddNewChatElement >> subscribeToRegistryViewModel [
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
GtLChatRegistryAddNewChatElement >> unsubscribeFromRegistryViewModel [
	super unsubscribeFromRegistryViewModel.

	self registryViewModel announcer unsubscribe: self
]

{ #category : #'private - updating' }
GtLChatRegistryAddNewChatElement >> updateConnectionElement [
	connectionElement label: self connectionLabel
]

{ #category : #initialization }
GtLChatRegistryAddNewChatElement >> updateConnectionsFrom: anEvent [

	self registryViewModel ifNil: [ ^ self ].
	self registryViewModel updateConnections.
]

{ #category : #'private - updating' }
GtLChatRegistryAddNewChatElement >> updateDescriptionElement [
	chatsElement label: self chatDescriptionLabel
]

{ #category : #'private - updating' }
GtLChatRegistryAddNewChatElement >> updateElement [
	self updateDescriptionElement.
	self updateConnectionElement
]
