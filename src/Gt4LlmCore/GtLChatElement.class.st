Class {
	#name : #GtLChatElement,
	#superclass : #BlElement,
	#traits : 'TBrLayoutResizable',
	#classTraits : 'TBrLayoutResizable classTrait',
	#instVars : [
		'chatViewModel',
		'listElement'
	],
	#category : 'Gt4LlmCore-UI - Elements'
}

{ #category : #'api - initialization' }
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

{ #category : #initialization }
GtLChatElement >> initialize [
	super initialize.

	self initializeListElement.
	self addChild: listElement as: #list.
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

{ #category : #'private - event handling' }
GtLChatElement >> onThreadRunAnnouncement: anAnnouncement [
	self enqueueTask: (BlTaskAction new action: [ self updateElement ])
]

{ #category : #'private - hooks' }
GtLChatElement >> subscribeToAssistantChatViewModel [
	self chatViewModel assistantChat weak
		when: GtLlmThreadRunAnnouncement
		send: #onThreadRunAnnouncement:
		to: self
]

{ #category : #'private - updating' }
GtLChatElement >> updateElement [
	| allItems |
	allItems := chatViewModel messageViewModels.
	listElement items: allItems.
	listElement scrollToItem: allItems last
]
