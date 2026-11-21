Class {
	#name : #GtLChatWithObjectDropdownContentStencil,
	#superclass : #BrStencil,
	#instVars : [
		'icon',
		'selectedModel',
		'anchor',
		'selectorElement',
		'object'
	],
	#category : #Gt4LlmCore
}

{ #category : #accessing }
GtLChatWithObjectDropdownContentStencil >> anchor [
	^ anchor
]

{ #category : #accessing }
GtLChatWithObjectDropdownContentStencil >> anchor: anObject [
	anchor := anObject
]

{ #category : #'as yet unclassified' }
GtLChatWithObjectDropdownContentStencil >> connectionLabel [
	^ selectedModel label
]

{ #category : #'as yet unclassified' }
GtLChatWithObjectDropdownContentStencil >> create [
	^ BrVerticalPane new
		hFitContent;
		alignCenterLeft;
		vFitContent;
		addChild: self newModelSelector;
		addChild: self newConfirmationButton
]

{ #category : #'as yet unclassified' }
GtLChatWithObjectDropdownContentStencil >> doAction [
	| aProvider chat storedObjectId storeObject |
	aProvider := selectedModel buildProvider.
	chat := GtLChatRegistry current newGtChatWithProvider: aProvider.
	storedObjectId := chat addNewObject: object reasonString: 'Initial object'.
	storeObject := chat objectStorage objectAt: storedObjectId.
	chat
		pageObjectExplanation: (LePage new
				title: 'Objects';
				addSnippet: (LeTextSnippet
						string: 'Relate the conversation primarily to the initial object with id '
								, storedObjectId);
				yourself).
	^ chat
]

{ #category : #'as yet unclassified' }
GtLChatWithObjectDropdownContentStencil >> groupedConnections [
	^ GtLConnectionRegistry instance connectableConnections groupedBy: [ :connection |
		connection providerClass providerName ]
]

{ #category : #'as yet unclassified' }
GtLChatWithObjectDropdownContentStencil >> hideDropdown [
	self anchor ifNotNil: [ :theAnchor | 
		theAnchor dispatchEvent: (BrDropdownHideWish new anchor: theAnchor) ]
]

{ #category : #'as yet unclassified' }
GtLChatWithObjectDropdownContentStencil >> initialize [
	icon := BrGlamorousVectorIcons chat.
	selectedModel := GtLConnectionRegistry instance defaultConnection.
]

{ #category : #'as yet unclassified' }
GtLChatWithObjectDropdownContentStencil >> newAvailableConnectionsMenu [
	| groupedConnections aMenuItems |
	groupedConnections := self groupedConnections.
	groupedConnections ifEmpty: [ ^ nil ].

	aMenuItems := BrMenuItems new.
	aMenuItems beGroupedElementType.
	(groupedConnections associations asSortedCollection: [ :a :b | a key <= b key ])
		doWithIndex: [ :eachAssociation :index | 
			| aGroupName someConnections |
			aGroupName := eachAssociation key.
			someConnections := eachAssociation value.
			someConnections
				do: [ :aConnection | 
					| anItem |
					anItem := BrMenuActionItem new
							label: [ aConnection label ];
							groupId: aGroupName asSymbol priority: index;
							action: [ :anElement :aButtonModel :anEvent | self onSelectModel: aConnection ].
					aMenuItems addItem: anItem ] ].

	^ aMenuItems
]

{ #category : #'as yet unclassified' }
GtLChatWithObjectDropdownContentStencil >> newConfirmationButton [
	^ BrButton new
		id: LePageConfirmationActionId;
		icon: icon;
		beSmallSize;
		requestFocus;
		aptitude: BrGlamorousButtonWithIconAptitude new;
		label: 'Chat';
		margin: (BlInsets
				top: 0
				left: 10
				bottom: 10
				right: 0);
		action: [ :aButton | 
			self hideDropdown.
			aButton phlow spawnObject: self doAction ];
		actionWithModifiers: [ :aButtonElement :aButtonModel :anEvent | 
			anEvent modifiers isPrimaryModifier
				ifTrue: [ BlSpace new
						withCommonSettings;
						objectInPager: self doAction;
						showFrom: aButtonElement ] ]
]

{ #category : #'as yet unclassified' }
GtLChatWithObjectDropdownContentStencil >> newModelSelector [
	^ BrHorizontalPane new
		fitContent;
		alignCenterLeft;
		addChild: self newSelectorLabel;
		addChild: self newSelectorMenu
]

{ #category : #'as yet unclassified' }
GtLChatWithObjectDropdownContentStencil >> newSelectorLabel [
	^ BrLabel new
		margin: ((BlInsets all: 10) withRight: 5);
		aptitude: BrGlamorousLabelAptitude new glamorousRegularFont;
		text: 'Chat with'
]

{ #category : #'as yet unclassified' }
GtLChatWithObjectDropdownContentStencil >> newSelectorMenu [
	| menu label |
	label := self connectionLabel.
	menu := self newAvailableConnectionsMenu.
	selectorElement := BrButton new
			margin: ((BlInsets all: 10) withLeft: 0);
			aptitude: BrGlamorousButtonWithLabelAptitude;
			addAptitude: BrGlamorousButtonIconDropdownAptitude;
			addAptitude: (BrGlamorousWithExplicitDropdownAptitude
					handle: [ BrButton new
							aptitude: BrGlamorousButtonWithLabelAptitude - BrGlamorousButtonExteriorAptitude;
							addAptitude: BrGlamorousButtonIconDropdownAptitude;
							label: label ]
					menu: menu);
			label: label.
	^ selectorElement
]

{ #category : #accessing }
GtLChatWithObjectDropdownContentStencil >> object [
	^ object
]

{ #category : #accessing }
GtLChatWithObjectDropdownContentStencil >> object: anObject [
	object := anObject
]

{ #category : #'as yet unclassified' }
GtLChatWithObjectDropdownContentStencil >> onSelectModel: aModel [
	selectedModel := aModel.
	BlTaskAction
		enqueueElement: self anchor
		action: [ selectorElement label: self connectionLabel ]
]
