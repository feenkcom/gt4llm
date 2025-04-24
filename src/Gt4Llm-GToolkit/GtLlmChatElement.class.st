Class {
	#name : #GtLlmChatElement,
	#superclass : #BlElement,
	#traits : 'TBrLayoutResizable',
	#classTraits : 'TBrLayoutResizable classTrait',
	#instVars : [
		'chatViewModel',
		'listElement'
	],
	#category : #'Gt4Llm-GToolkit'
}

{ #category : #'as yet unclassified' }
GtLlmChatElement >> beSync [
	self chatViewModel beSync
]

{ #category : #accessing }
GtLlmChatElement >> chatViewModel [
	^ chatViewModel
]

{ #category : #accessing }
GtLlmChatElement >> chatViewModel: anObject [
	chatViewModel := anObject.

	self subscribeToAssistantChatViewModel.
	self updateElement
]

{ #category : #'as yet unclassified' }
GtLlmChatElement >> initialize [
	super initialize.

	self initializeListElement.
	self addChild: listElement as: #list.
	self padding: (BlInsets all: 3).
	self matchParent
]

{ #category : #'as yet unclassified' }
GtLlmChatElement >> initializeListElement [
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
GtLlmChatElement >> onThreadRunAnnouncement: anAnnouncement [
	self enqueueTask: (BlTaskAction new action: [ self updateElement ])
]

{ #category : #'as yet unclassified' }
GtLlmChatElement >> subscribeToAssistantChatViewModel [
	self chatViewModel assistantChat weak
		when: GtLlmThreadRunAnnouncement
		send: #onThreadRunAnnouncement:
		to: self
]

{ #category : #'as yet unclassified' }
GtLlmChatElement >> updateElement [
	| allItems |
	allItems := chatViewModel threadMessageViewModels.
	listElement items: allItems.
	listElement scrollToItem: allItems last
]
