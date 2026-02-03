Class {
	#name : #GtLChatElement,
	#superclass : #BlElement,
	#traits : 'TBrLayoutResizable + TGtLWithChatViewModel',
	#classTraits : 'TBrLayoutResizable classTrait + TGtLWithChatViewModel classTrait',
	#instVars : [
		'listElement',
		'listElementUpdater'
	],
	#category : 'Gt4LlmCore-UI - Elements'
}

{ #category : #accessing }
GtLChatElement >> chatViewModel [
	^ chatViewModel
]

{ #category : #initialization }
GtLChatElement >> initialize [
	super initialize.

	self initializeListElement.
	self initializeListElementUpdater.
	self addChild: listElement as: #'chat--message-list'.
	self padding: (BlInsets all: 3).
	self matchParent
]

{ #category : #initialization }
GtLChatElement >> initializeListElement [
	listElement := BrSimpleList vertical
			hMatchParent;
			vMatchParent;
			padding: (BlInsets all: 5);
			itemId: [ :aViewModel :anIndex | aViewModel id ];
			itemType: [ :aFactory :aViewModel :anIndex | aViewModel elementClass ];
			itemStencil: [ :anElementClass :aListWidget | anElementClass newForChatList ];
			itemDataBinder: [ :aMessageElement :aViewModel :anIndex | 
				aMessageElement 
					id: (GtLMessageElementId indexed: anIndex);
					messageViewModel: aViewModel ]
]

{ #category : #initialization }
GtLChatElement >> initializeListElementUpdater [
	listElementUpdater := BrElementUpdater new
			element: self selector: #updateElement;
			postponedDuration: 300 milliseconds
]

{ #category : #'private - chat view model' }
GtLChatElement >> onChatViewModelChanged [
	self updateElement
]

{ #category : #'private - event handling' }
GtLChatElement >> onChatViewModelMessageAdded: anAnnouncement [
	self chatViewModel = anAnnouncement chatViewModel ifFalse: [ ^ self ].

	BlTaskAction enqueueElement: self action: [ listElementUpdater requestUpdate ]
]

{ #category : #'private - event handling' }
GtLChatElement >> onThreadRunAnnouncement: anAnnouncement [
	self enqueueTask: (BlTaskAction new action: [ listElementUpdater requestUpdate ])
]

{ #category : #'private - chat view model' }
GtLChatElement >> subscribeToChatViewModel [
	self chatViewModel weak
		when: GtLChatViewModelMessageAdded
		send: #onChatViewModelMessageAdded:
		to: self.

	self flag: #todo.	"Remove this announcement from our new model"
	self chatViewModel chat weak
		when: GtLlmThreadRunAnnouncement
		send: #onThreadRunAnnouncement:
		to: self
]

{ #category : #'private - chat view model' }
GtLChatElement >> unsubscribeFromChatViewModel [
	self chatViewModel announcer unsubscribe: self.
	self chatViewModel chat announcer unsubscribe: self
]

{ #category : #'private - updating' }
GtLChatElement >> updateElement [
	| allItems |
	allItems := chatViewModel messageViewModels.
	listElement items: allItems.
	listElement scrollToItem: allItems last
]
