Class {
	#name : #GtLChatElement,
	#superclass : #BlElement,
	#traits : 'TBrLayoutResizable',
	#classTraits : 'TBrLayoutResizable classTrait',
	#instVars : [
		'chatViewModel',
		'listElement'
	],
	#category : #'Gt4LlmCore-UI'
}

{ #category : #'as yet unclassified' }
GtLChatElement >> beSync [
	self chatViewModel beSync
]

{ #category : #accessing }
GtLChatElement >> chatViewModel [
	^ chatViewModel
]

{ #category : #accessing }
GtLChatElement >> chatViewModel: anObject [
	chatViewModel := anObject.

	self subscribeToAssistantChatViewModel.
	self updateElement
]

{ #category : #'as yet unclassified' }
GtLChatElement >> initialize [
	super initialize.

	self initializeListElement.
	self addChild: listElement as: #list.
	self padding: (BlInsets all: 3).
	self matchParent
]

{ #category : #'as yet unclassified' }
GtLChatElement >> initializeListElement [
	listElement := BrSimpleList vertical
			hMatchParent;
			vMatchParent;
			padding: (BlInsets all: 5);
			itemType: [ :aFactory :anItem :anIndex | anItem elementClass ];
			itemId: [ :anItem :anIndex | anItem id ];
			itemStencil: [ :anElementClass :aListWidget | 
				anElementClass newForChatList ];
			itemDataBinder: [ :anItemElement :anItem | anItemElement threadMessageViewModel: anItem ]
]

{ #category : #'as yet unclassified' }
GtLChatElement >> onThreadRunAnnouncement: anAnnouncement [
	self enqueueTask: (BlTaskAction new action: [ self updateElement ])
]

{ #category : #'as yet unclassified' }
GtLChatElement >> subscribeToAssistantChatViewModel [
	self chatViewModel assistantChat weak
		when: GtLlmThreadRunAnnouncement
		send: #onThreadRunAnnouncement:
		to: self
]

{ #category : #'as yet unclassified' }
GtLChatElement >> updateElement [
	| allItems |
	allItems := chatViewModel messageViewModels.
	listElement items: allItems.
	listElement scrollToItem: allItems last
]
