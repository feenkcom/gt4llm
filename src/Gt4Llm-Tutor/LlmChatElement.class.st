Class {
	#name : #LlmChatElement,
	#superclass : #BlElement,
	#traits : 'TBrLayoutResizable',
	#classTraits : 'TBrLayoutResizable classTrait',
	#instVars : [
		'chatViewModel',
		'listElement'
	],
	#category : #'Gt4Llm-Tutor-Chats'
}

{ #category : #accessing }
LlmChatElement >> chatViewModel [
	^ chatViewModel
]

{ #category : #accessing }
LlmChatElement >> chatViewModel: anObject [
	chatViewModel := anObject.
	
	self updateElement
]

{ #category : #'as yet unclassified' }
LlmChatElement >> initialize [
	super initialize.

	self initializeListElement.
	self addChild: listElement as: #list.
	self padding: (BlInsets all: 3).
	self matchParent
]

{ #category : #'as yet unclassified' }
LlmChatElement >> initializeListElement [
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
LlmChatElement >> onThreadRunAnnouncement: anAnnouncement [
	self enqueueTask: (BlTaskAction new action: [ self updateElement ])
]

{ #category : #'as yet unclassified' }
LlmChatElement >> subscribeToAssistantChatViewModel [
	self chat weak
		when: GtOpenAIThreadRunAnnouncement
		send: #onThreadRunAnnouncement:
		to: self
]

{ #category : #'as yet unclassified' }
LlmChatElement >> updateElement [
	| allItems |
	allItems := chatViewModel threadMessageViewModels.
	listElement items: allItems.
	listElement scrollToItem: allItems last
]
