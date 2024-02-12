Class {
	#name : #Gt4OpenAIAssistantChatElement,
	#superclass : #BlElement,
	#traits : 'TGt4OpenAIWithAssistantChat + TBrLayoutResizable',
	#classTraits : 'TGt4OpenAIWithAssistantChat classTrait + TBrLayoutResizable classTrait',
	#instVars : [
		'listElement'
	],
	#category : #'Gt4OpenAI-Widgets'
}

{ #category : #'private - updating' }
Gt4OpenAIAssistantChatElement >> allListItems [
	^ assistantChat messages asArray reversed
		copyWith: (Gt4OpenAINewThreadMessage new assistantChat: assistantChat)
]

{ #category : #'initialization ' }
Gt4OpenAIAssistantChatElement >> defaultLayout [
	^ BlLinearLayout vertical
]

{ #category : #initialization }
Gt4OpenAIAssistantChatElement >> initialize [
	super initialize.
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
	self updateElement
]

{ #category : #'private - updating' }
Gt4OpenAIAssistantChatElement >> updateElement [
	self updateListElement
]

{ #category : #'private - updating' }
Gt4OpenAIAssistantChatElement >> updateListElement [
	listElement items: self allListItems
]
