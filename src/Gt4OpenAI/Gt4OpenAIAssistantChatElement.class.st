Class {
	#name : #Gt4OpenAIAssistantChatElement,
	#superclass : #BlElement,
	#traits : 'TGt4OpenAIWithAssistantChat + TBrLayoutResizable',
	#classTraits : 'TGt4OpenAIWithAssistantChat classTrait + TBrLayoutResizable classTrait',
	#instVars : [
		'listElement',
		'newThreadMessage'
	],
	#category : #'Gt4OpenAI-Widgets'
}

{ #category : #'private - updating' }
Gt4OpenAIAssistantChatElement >> allListItems [
	^ assistantChat messages asArray reversed copyWith: newThreadMessage
]

{ #category : #'initialization ' }
Gt4OpenAIAssistantChatElement >> defaultLayout [
	^ BlLinearLayout vertical
]

{ #category : #initialization }
Gt4OpenAIAssistantChatElement >> initialize [
	super initialize.
	newThreadMessage := Gt4OpenAINewThreadMessage new.
	
	self initializeListElement.
	self addChild: listElement as: #list.
	self padding: (BlInsets all: 3).
	self matchParent
]

{ #category : #initialization }
Gt4OpenAIAssistantChatElement >> initializeListElement [
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
Gt4OpenAIAssistantChatElement >> onAssistantChatChanged [
	self updateNewThreadMessage.
	self updateElement
]

{ #category : #'private - event handling' }
Gt4OpenAIAssistantChatElement >> onThreadRunAnnouncement: anAnnouncement [
	self updateListElement
]

{ #category : #'private - hooks' }
Gt4OpenAIAssistantChatElement >> subscribeToAssistantChat [
	assistantChat weak
		when: Gt4OpenAIThreadRunAnnouncement
		send: #onThreadRunAnnouncement:
		to: self
]

{ #category : #'private - hooks' }
Gt4OpenAIAssistantChatElement >> unsubscribeFromAssistantChat [
	assistantChat unsubscribe: self
]

{ #category : #'private - updating' }
Gt4OpenAIAssistantChatElement >> updateElement [
	self updateListElement
]

{ #category : #'private - updating' }
Gt4OpenAIAssistantChatElement >> updateListElement [
	| allItems |
	allItems := self allListItems.
	listElement items: allItems.
	listElement scrollToItem: allItems last 
]

{ #category : #'private - updating' }
Gt4OpenAIAssistantChatElement >> updateNewThreadMessage [
	newThreadMessage assistantChat: assistantChat
]
