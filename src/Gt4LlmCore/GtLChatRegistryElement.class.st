Class {
	#name : #GtLChatRegistryElement,
	#superclass : #GtLChatRegistryBasicElement,
	#instVars : [
		'addNewChatElement',
		'listElement'
	],
	#category : #'Gt4LlmCore-UI - Registry'
}

{ #category : #initialization }
GtLChatRegistryElement >> defaultLayout [
	^ BlLinearLayout vertical
		alignTopLeft;
		cellSpacing: 10
]

{ #category : #initialization }
GtLChatRegistryElement >> initialize [
	super initialize.

	self initializeListElement.
	self initializeAddNewChatElement.

	self
		addChild: ((self newLabelWithText: 'Chats') margin: (BlInsets left: 10))
		as: #header.
	self addChild: listElement.
	self addChild: addNewChatElement.

	self
		addAptitude: (BrLayoutResizerAptitude new
				common: listElement).

	self
		hMatchParent;
		vFitContentLimited
]

{ #category : #initialization }
GtLChatRegistryElement >> initializeAddNewChatElement [
	addNewChatElement := GtLChatRegistryAddNewChatElement new
			hMatchParent;
			padding: (BlInsets top: 3 left: 0 bottom: 3 right: 0)
]

{ #category : #initialization }
GtLChatRegistryElement >> initializeListElement [
	listElement := GtLChatRegistryListElement new
]

{ #category : #'private - instance creation' }
GtLChatRegistryElement >> newLabelWithText: aString [
	^ BrLabel new
		aptitude: BrGlamorousLabelAptitude new;
		text: aString
]

{ #category : #updating }
GtLChatRegistryElement >> onRegistryViewModelChanged [
	super onRegistryViewModelChanged.

	listElement registryViewModel: self registryViewModel.
	addNewChatElement registryViewModel: self registryViewModel.
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
