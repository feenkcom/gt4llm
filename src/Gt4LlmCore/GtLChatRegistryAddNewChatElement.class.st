Class {
	#name : #GtLChatRegistryAddNewChatElement,
	#superclass : #GtLChatRegistryBasicElement,
	#instVars : [
		'connectionElement'
	],
	#category : #'Gt4LlmCore-UI - Registry'
}

{ #category : #initialization }
GtLChatRegistryAddNewChatElement >> connectionLabel [
	^ self registryViewModel
		ifNotNil: [ :aViewModel | aViewModel selectedConnection ifNotNil: #label ifNil: [ 'Connection' ] ]
		ifNil: [ 'Connection' ]
]

{ #category : #initialization }
GtLChatRegistryAddNewChatElement >> defaultLayout [
	^ BlLinearLayout horizontal alignCenterLeft
]

{ #category : #initialization }
GtLChatRegistryAddNewChatElement >> initialize [
	super initialize.

	self initializeConnectionElement.

	self
		addChild: ((self newLabelWithText: 'New chat with') margin: (BlInsets right: 3)).
	self addChild: connectionElement.

	self fitContent
]

{ #category : #initialization }
GtLChatRegistryAddNewChatElement >> initializeConnectionElement [
	connectionElement := self newConnectionBasicElement
			addAptitude: (BrGlamorousWithExplicitDropdownAptitude new
					handle: [ self newConnectionBasicElement ]
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
GtLChatRegistryAddNewChatElement >> newConnectionBasicElement [
	^ BrButton new
		aptitude: BrGlamorousButtonWithLabelAptitude;
		label: self connectionLabel
]

{ #category : #initialization }
GtLChatRegistryAddNewChatElement >> newLabelWithText: aString [
	^ BrLabel new
		aptitude: BrGlamorousLabelAptitude new;
		text: aString
]

{ #category : #'private - hooks' }
GtLChatRegistryAddNewChatElement >> onRegistryViewModelChanged [
	super onRegistryViewModelChanged.
	
	self updateElement
]

{ #category : #'private - event handling' }
GtLChatRegistryAddNewChatElement >> onSelectConnection: aConnection [
	self registryViewModel selectedConnection: aConnection source: self.
	
	BlTaskAction enqueueElement: self action: [ self updateElement ]
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
GtLChatRegistryAddNewChatElement >> updateElement [
	self updateConnectionElement
]
