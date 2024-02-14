Class {
	#name : #GtOpenAIAssistantChatElement,
	#superclass : #BlElement,
	#traits : 'TGtOpenAIWithAssistantChat + TBrLayoutResizable',
	#classTraits : 'TGtOpenAIWithAssistantChat classTrait + TBrLayoutResizable classTrait',
	#instVars : [
		'listElement',
		'newThreadMessage'
	],
	#category : #'Gt4OpenAI-Widgets'
}

{ #category : #'private - updating' }
GtOpenAIAssistantChatElement >> allListItems [
	^ assistantChat messages asArray reversed copyWith: newThreadMessage
]

{ #category : #'initialization ' }
GtOpenAIAssistantChatElement >> defaultLayout [
	^ BlLinearLayout vertical
]

{ #category : #initialization }
GtOpenAIAssistantChatElement >> initialize [
	super initialize.
	newThreadMessage := GtOpenAINewThreadMessage new.
	
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
			itemDataBinder: [ :anItemElement :anItem | anItemElement threadMessage: anItem ]
]

{ #category : #'private - hooks' }
GtOpenAIAssistantChatElement >> onAssistantChatChanged [
	self updateNewThreadMessage.
	self updateElement
]

{ #category : #'private - event handling' }
GtOpenAIAssistantChatElement >> onThreadRunAnnouncement: anAnnouncement [
	self updateListElement
]

{ #category : #'private - hooks' }
GtOpenAIAssistantChatElement >> subscribeToAssistantChat [
	assistantChat weak
		when: GtOpenAIThreadRunAnnouncement
		send: #onThreadRunAnnouncement:
		to: self
]

{ #category : #'private - hooks' }
GtOpenAIAssistantChatElement >> unsubscribeFromAssistantChat [
	assistantChat unsubscribe: self
]

{ #category : #'private - updating' }
GtOpenAIAssistantChatElement >> updateElement [
	self updateListElement
]

{ #category : #'private - updating' }
GtOpenAIAssistantChatElement >> updateListElement [
	| allItems |
	allItems := self allListItems.
	listElement items: allItems.
	listElement scrollToItem: allItems last 
]

{ #category : #'private - updating' }
GtOpenAIAssistantChatElement >> updateNewThreadMessage [
	newThreadMessage assistantChat: assistantChat
]
