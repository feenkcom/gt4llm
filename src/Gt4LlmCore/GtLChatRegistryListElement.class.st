"
I render the list of chats from a registry view model.
"
Class {
	#name : #GtLChatRegistryListElement,
	#superclass : #GtLChatRegistryBasicElement,
	#instVars : [
		'listElement'
	],
	#category : #'Gt4LlmCore-UI - Registry'
}

{ #category : #layout }
GtLChatRegistryListElement >> defaultLayout [
	^ BlLinearLayout vertical
]

{ #category : #initialization }
GtLChatRegistryListElement >> initialize [
	super initialize.
	
	self initializeListElement.
	
	self addChild: listElement.
	
	self addAptitude: (BrLayoutResizerAptitude new common: listElement).
		
	self
		hMatchParent;
		vFitContentLimited.
]

{ #category : #initialization }
GtLChatRegistryListElement >> initializeListElement [
	listElement := BrColumnedList new
			aptitude: BrColumnedMultiListAptitude;
			rowStencil: (BrGlamorousColumnedListItemElementWithContextMenuDecorator new
					contextMenuStencil: [ :itemElement :itemObject :itemIndex :itemType | 
						| someChats |
						someChats := listElement selectedItems.
						((someChats includes: itemObject) and: [ someChats size > 1 ])
							ifTrue: [ self newContextMenuModelForItemElement: itemElement chats: someChats ]
							ifFalse: [ self
									newContextMenuModelForItemElement: itemElement
									object: itemObject
									index: itemIndex
									type: itemType ] ];
					stencilBuilder: (BrGlamorousColumnedListSelectableRowElementStencilBuilder new
							cellSpacing: 10;
							padding: (BlInsets top: 3 bottom: 3)));
			rowDataBinder: [ :aRowElement :anItemObject :aRowPosition |
				aRowElement id: (#'registry-chat' asBlocElementId indexed: aRowPosition) ];
			addEventHandler: (GtPhlowListToSelectHandler new
					transformation: [ :aViewModelOrCollection | 
						aViewModelOrCollection isCollection
							ifTrue: [ aViewModelOrCollection collect: #chat as: Array ]
							ifFalse: [ aViewModelOrCollection chat ] ]);
			addAptitude: (BrColumnedListHeaderAptitude new cellSpacing: 10).

	listElement column
		title: 'Chat';
		weight: 3;
		cellStencil: [ GtLChatNameLabelElement new ];
		dataBinder: [ :aCellElement :aChatViewModel :anIndex | aCellElement chatViewModel: aChatViewModel ].

	listElement column
		title: 'Status';
		width: 60;
		cellStencil: [ GtLChatStateLabelElement new ];
		dataBinder: [ :aCellElement :aChatViewModel :anIndex | aCellElement chatViewModel: aChatViewModel ]
]

{ #category : #initialization }
GtLChatRegistryListElement >> newContextMenuModelForItemElement: itemElement chats: someChatViewModels [
	| aGroup |
	aGroup := GtLChatRegistryGroup withAll: (someChatViewModels collect: #chat).

	^ GtLChatRegistryActionTarget
		menuItemsForObject: aGroup
		inContext: (GtPhlowContext new
				at: #chatRegistry put: self registryViewModel registry;
				yourself)
		hostElement: itemElement
]

{ #category : #initialization }
GtLChatRegistryListElement >> newContextMenuModelForItemElement: itemElement object: itemChatViewModel index: itemIndex type: itemType [
	^ GtLChatRegistryActionTarget
		menuItemsForObject: itemChatViewModel chat
		inContext: (GtPhlowContext new
				at: #chatRegistry put: self registryViewModel registry;
				yourself)
		hostElement: itemElement
]

{ #category : #'private - event handling' }
GtLChatRegistryListElement >> onChatRegistryViewModelAddedAnnouncement: anAnnouncement [
	anAnnouncement registryViewModel = self registryViewModel ifFalse: [ ^ self ].

	BlTaskAction enqueueElement: self action: [ self updateElement ]
]

{ #category : #'private - event handling' }
GtLChatRegistryListElement >> onChatRegistryViewModelRemovedAnnouncement: anAnnouncement [
	anAnnouncement registryViewModel = self registryViewModel ifFalse: [ ^ self ].

	BlTaskAction enqueueElement: self action: [ 
		self updateSelectionWithout: anAnnouncement chatViewModel.
		self updateElement ]
]

{ #category : #'api - hooks' }
GtLChatRegistryListElement >> onRegistryViewModelChanged [
	super onRegistryViewModelChanged.
	self updateElement
]

{ #category : #'api - hooks' }
GtLChatRegistryListElement >> subscribeToRegistryViewModel [
	super subscribeToRegistryViewModel.

	self registryViewModel announcer weak
		when: GtLChatRegistryViewModelRemovedAnnouncement
			send: #onChatRegistryViewModelRemovedAnnouncement:
			to: self;
		when: GtLChatRegistryViewModelAddedAnnouncement
			send: #onChatRegistryViewModelAddedAnnouncement:
			to: self
]

{ #category : #'api - hooks' }
GtLChatRegistryListElement >> unsubscribeFromRegistryViewModel [
	super unsubscribeFromRegistryViewModel.

	self registryViewModel announcer unsubscribe: self
]

{ #category : #'private - updating' }
GtLChatRegistryListElement >> updateElement [
	| someChats |
	someChats := self registryViewModel chatViewModels.
	listElement items: someChats
]

{ #category : #'private - updating' }
GtLChatRegistryListElement >> updateSelectionWithout: aChatViewModel [
	listElement deselectAll
]
