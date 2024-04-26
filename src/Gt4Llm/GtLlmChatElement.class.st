Class {
	#name : #GtLlmChatElement,
	#superclass : #BlElement,
	#traits : 'TGtLlmWithChatViewModel + TBrLayoutResizable',
	#classTraits : 'TGtLlmWithChatViewModel classTrait + TBrLayoutResizable classTrait',
	#instVars : [
		'listElement'
	],
	#category : #'Gt4Llm-Widgets'
}

{ #category : #'initialization ' }
GtLlmChatElement >> defaultLayout [
	^ BlLinearLayout vertical
]

{ #category : #initialization }
GtLlmChatElement >> initialize [
	super initialize.

	self initializeListElement.
	self addChild: listElement as: #list.
	self padding: (BlInsets all: 3).
	self matchParent
]

{ #category : #initialization }
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

{ #category : #'private - hooks' }
GtLlmChatElement >> onAssistantChatViewModelChanged [
	self updateElement
]

{ #category : #'private - event handling' }
GtLlmChatElement >> onThreadRunAnnouncement: anAnnouncement [
	self enqueueTask: (BlTaskAction new action: [ self updateListElement ])
]

{ #category : #'private - hooks' }
GtLlmChatElement >> subscribeToAssistantChatViewModel [
	self assistantChat weak
		when: GtOpenAIThreadRunAnnouncement
		send: #onThreadRunAnnouncement:
		to: self
]

{ #category : #'private - hooks' }
GtLlmChatElement >> unsubscribeFromAssistantChatViewModel [
	self assistantChat unsubscribe: self
]

{ #category : #'private - updating' }
GtLlmChatElement >> updateElement [
	self updateListElement
]

{ #category : #'private - updating' }
GtLlmChatElement >> updateListElement [
	| allItems |
	allItems := assistantChatViewModel threadMessageViewModels.
	listElement items: allItems.
	listElement scrollToItem: allItems last
]
