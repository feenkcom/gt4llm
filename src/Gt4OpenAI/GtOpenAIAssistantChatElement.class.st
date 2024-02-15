Class {
	#name : #GtOpenAIAssistantChatElement,
	#superclass : #BlElement,
	#traits : 'TGtOpenAIWithAssistantChatViewModel + TBrLayoutResizable',
	#classTraits : 'TGtOpenAIWithAssistantChatViewModel classTrait + TBrLayoutResizable classTrait',
	#instVars : [
		'listElement'
	],
	#category : #'Gt4OpenAI-Widgets'
}

{ #category : #'initialization ' }
GtOpenAIAssistantChatElement >> defaultLayout [
	^ BlLinearLayout vertical
]

{ #category : #initialization }
GtOpenAIAssistantChatElement >> initialize [
	super initialize.

	self initializeListElement.
	self addChild: listElement as: #list.
	self padding: (BlInsets all: 3).
	self matchParent
]

{ #category : #initialization }
GtOpenAIAssistantChatElement >> initializeListElement [
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
GtOpenAIAssistantChatElement >> onAssistantChatViewModelChanged [
	self updateElement
]

{ #category : #'private - event handling' }
GtOpenAIAssistantChatElement >> onThreadRunAnnouncement: anAnnouncement [
	self updateListElement
]

{ #category : #'private - hooks' }
GtOpenAIAssistantChatElement >> subscribeToAssistantChatViewModel [
	self assistantChat weak
		when: GtOpenAIThreadRunAnnouncement
		send: #onThreadRunAnnouncement:
		to: self
]

{ #category : #'private - hooks' }
GtOpenAIAssistantChatElement >> unsubscribeFromAssistantChatViewModel [
	self assistantChat unsubscribe: self
]

{ #category : #'private - updating' }
GtOpenAIAssistantChatElement >> updateElement [
	self updateListElement
]

{ #category : #'private - updating' }
GtOpenAIAssistantChatElement >> updateListElement [
	| allItems |
	allItems := assistantChatViewModel threadMessageViewModels.
	listElement items: allItems.
	listElement scrollToItem: allItems last
]
