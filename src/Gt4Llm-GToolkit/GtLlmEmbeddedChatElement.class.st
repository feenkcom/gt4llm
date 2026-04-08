Class {
	#name : #GtLlmEmbeddedChatElement,
	#superclass : #GtLlmChatElement,
	#category : 'Gt4Llm-GToolkit-UI'
}

{ #category : #'as yet unclassified' }
GtLlmEmbeddedChatElement >> initialize [
	super initialize.

	self fitContent.
	self background: Color white.
	self layout: BlLinearLayout vertical.

	self addChildFirst: self toolbar
]

{ #category : #'as yet unclassified' }
GtLlmEmbeddedChatElement >> initializeListElement [
	listElement := BrSimpleList vertical fitContentLimited
			padding: (BlInsets all: 5);
			itemType: [ :aFactory :anItem :anIndex | anItem elementClass ];
			itemId: [ :anItem :anIndex | anItem id ];
			itemStencil: [ :anElementClass :aListWidget | anElementClass newForChatList hExact: 500 ];
			itemDataBinder: [ :anItemElement :anItem | anItemElement threadMessageViewModel: anItem ]
]

{ #category : #'as yet unclassified' }
GtLlmEmbeddedChatElement >> toolbar [
	^ BrToolbar new vFitContent hMatchParent
		aptitude: BrGlamorousToolbarAptitude new;
		addChild: BrFrame new hMatchParent vFitContent;
		addChild: (BrButton new
				aptitude: BrGlamorousButtonWithIconAptitude;
				label: 'Inspect';
				icon: BrGlamorousVectorIcons inspect;
				action: [ self phlow spawnObject: self chatViewModel assistantChat ])
]
