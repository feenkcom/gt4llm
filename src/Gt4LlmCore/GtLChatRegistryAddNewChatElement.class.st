Class {
	#name : #GtLChatRegistryAddNewChatElement,
	#superclass : #GtLChatRegistryBasicElement,
	#instVars : [
		'connectionElement',
		'chatsElement',
		'addChatElement'
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

{ #category : #initialization }
GtLChatRegistryAddNewChatElement >> initialize [
	super initialize.

	self initializeChatDescriptionsElement.
	self initializeConnectionElement.
	self initializeAddChatElement.

	self addChild: chatsElement.
	self addChild: (self newLabelWithText: 'with').
	self addChild: connectionElement.
	self addChild: addChatElement.

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
GtLChatRegistryAddNewChatElement >> newAvailableConnectionsMenuModel [
	| someConnections aMenuItems |
	someConnections := self registryViewModel connectableConnections.
	someConnections ifEmpty: [ ^ nil ].

	aMenuItems := BrMenuItems new.
	someConnections
		do: [ :eachConnection | 
			| anItem |
			anItem := BrMenuActionItem new
					label: [ eachConnection label ];
					action: [ :anElement :aButtonModel :anEvent | 
						self onSelectConnection: eachConnection ].
			aMenuItems addItem: anItem ].

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
	self registryViewModel ifNil: [ ^ self ].
	
	self registryViewModel addChat
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
	super registryViewModel: anObject asChatRegistryWithConnectionsViewModel
]

{ #category : #'private - updating' }
GtLChatRegistryAddNewChatElement >> updateConnectionElement [
	connectionElement label: self connectionLabel
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
