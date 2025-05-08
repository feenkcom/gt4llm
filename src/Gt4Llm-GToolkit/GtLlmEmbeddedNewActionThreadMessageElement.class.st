Class {
	#name : #GtLlmEmbeddedNewActionThreadMessageElement,
	#superclass : #BlElement,
	#traits : 'TBrLayoutResizable + TGtLlmWithThreadMessageViewModel',
	#classTraits : 'TBrLayoutResizable classTrait + TGtLlmWithThreadMessageViewModel classTrait',
	#instVars : [
		'contentsElement',
		'sendButton',
		'toolbar',
		'toggleGroup',
		'descriptionElement'
	],
	#category : #'Gt4Llm-GToolkit'
}

{ #category : #factory }
GtLlmEmbeddedNewActionThreadMessageElement class >> newForChatList [
	^ self new
		geometry: (BlRoundedRectangleGeometry cornerRadius: 2);
		background: Color white;
		addAptitude: BrGlamorousFocusableShadowAptitude new;
		margin: (BlInsets
				top: 3
				bottom: 12
				left: 5
				right: 5)
]

{ #category : #'as yet unclassified' }
GtLlmEmbeddedNewActionThreadMessageElement >> buildAttachButton [
	^ BrButton new
		fitContent;
		beSmallSize;
		aptitude: BrGlamorousButtonWithIconAptitude new
				+ (BrGlamorousWithExplicitDropdownAptitude
						handle: [ BrButton new
								aptitude: BrGlamorousButtonWithIconAptitude - BrGlamorousButtonWithLabelTooltipAptitude2
										- BrGlamorousButtonExteriorAptitude;
								icon: BrGlamorousVectorIcons changes ]
						content: [ :aDropdown | 
							BrFileSelector new
								folder: FileLocator home;
								padding: (BlInsets all: 8);
								fileFilterBlock: [ :aFileReference | 
									aFileReference isFile
										and: [ (FileSystemDirectoryEntry reference: aFileReference) isHidden not ] ];
								okAction: [ :aFile | 
									self threadMessageViewModel attachFile: aFile.
									aDropdown fireEvent: BrDropdownHideWish new ] ]);
		label: 'Attach';
		icon: BrGlamorousVectorIcons changes;
		margin: (BlInsets all: 3);
		constraintsDo: [ :c | 
			c linear vertical alignBottom.
			c linear horizontal alignLeft ]
]

{ #category : #'as yet unclassified' }
GtLlmEmbeddedNewActionThreadMessageElement >> buildProviderButton [
	| aButton |
	aButton := BrButton new beSmallSize
			aptitude: BrGlamorousButtonWithLabelAptitude new
					+ (BrGlamorousWithExplicitDropdownAptitude
							handle: [ BrButton new beSmallSize
									aptitude: BrGlamorousButtonWithLabelAptitude - BrGlamorousButtonExteriorAptitude;
									label: (GtLlmConnectionRegistry uniqueInstance
											connectionFor: self threadMessageViewModel provider) connectionString ]
							content: [ | aList |
								aList := BrSimpleList new fitContent
										items: GtLlmConnectionRegistry uniqueInstance connectableConnections;
										itemStencil: [ BrLabel new
												aptitude: BrGlamorousLabelAptitude new
														+ (BrStyleCommonAptitude new
																selected: [ :aStyle | aStyle background: BrGlamorousColors selectedListItemColor ];
																hovered: [ :aStyle | aStyle background: BrGlamorousColors hoveredListItemColor ]);
												padding: (BlInsets all: 5) ];
										itemDataBinder: [ :aLabel :anItem | aLabel text: anItem connectionString ];
										when: BrSelectionChanged
											do: [ :anEvent | 
												self threadMessageViewModel
													provider: (GtLlmConnectionRegistry uniqueInstance connections at: anEvent indices first)
															buildProvider.
												aButton
													label: (GtLlmConnectionRegistry uniqueInstance
															connectionFor: self threadMessageViewModel provider)
															connectionString.
												aList fireEvent: BrDropdownHideWish new ] ]);
			label: ((GtLlmConnectionRegistry uniqueInstance
					connectionFor: self threadMessageViewModel provider)
					ifNil: [ self threadMessageViewModel provider asString ]
					ifNotNil: #connectionString).
	^ aButton
]

{ #category : #'initialization ' }
GtLlmEmbeddedNewActionThreadMessageElement >> buildSendButton [
	^ sendButton := BrButton new
			fitContent;
			beSmallSize;
			id: #send;
			aptitude: BrGlamorousButtonWithIconAptitude;
			label: 'Send';
			icon: BrGlamorousVectorIcons accept;
			action: [ :aButton | self sendMessageFrom: aButton ];
			margin: (BlInsets all: 3);
			constraintsDo: [ :c | 
				c linear vertical alignBottom.
				c linear horizontal alignLeft ]
]

{ #category : #initialization }
GtLlmEmbeddedNewActionThreadMessageElement >> defaultLayout [
	^ BlLinearLayout vertical
]

{ #category : #'as yet unclassified' }
GtLlmEmbeddedNewActionThreadMessageElement >> disableSend [
	sendButton disable
]

{ #category : #'as yet unclassified' }
GtLlmEmbeddedNewActionThreadMessageElement >> enableSend [
	sendButton enable
]

{ #category : #'initialization ' }
GtLlmEmbeddedNewActionThreadMessageElement >> initialize [
	super initialize.

	self initializeToggleGroup.
	self initializeDescriptionElement.
	self initializeContentsElement.
	self initializeToolbar.
	self
		addChild: (BrScrollPane new vFitContent
				aptitude: BrScrollPaneAptitude;
				content: toggleGroup)
		as: #toggle.
	self addChild: descriptionElement as: #description.
	self addChild: contentsElement as: #contents.
	self addChild: toolbar as: #toolbar.

	self hMatchParent.
	self vFitContent
]

{ #category : #'initialization ' }
GtLlmEmbeddedNewActionThreadMessageElement >> initializeContentsElement [
	contentsElement := BrEditor new
			hMatchParent;
			vFitContentLimited;
			aptitude: BrGlamorousRegularEditorAptitude new;
			visibility: BlVisibility gone.

	contentsElement
		addShortcut: (BrEditorShortcut new
				name: 'Send message';
				description: 'Send message to the OpenAI assistant chat';
				combination: BlKeyCombination primaryReturn;
				performBlock: [ :aBrTextEditor | self sendMessage ];
				yourself)
]

{ #category : #'initialization ' }
GtLlmEmbeddedNewActionThreadMessageElement >> initializeDescriptionElement [
	descriptionElement := BrEditor new beReadOnlyWithoutSelection
			hMatchParent;
			vFitContentLimited;
			aptitude: (BrGlamorousRegularEditorAptitude new
					foreground: BrGlamorousColors disabledButtonTextColor)
]

{ #category : #'initialization ' }
GtLlmEmbeddedNewActionThreadMessageElement >> initializeToggleGroup [
	toggleGroup := BrToggleGroup new vFitContent
			aptitude: BrGlamorousToggleGroupAptitude new;
			margin: (BlInsets
					top: 3
					bottom: 0
					left: 8
					right: 8)
]

{ #category : #'initialization ' }
GtLlmEmbeddedNewActionThreadMessageElement >> initializeToolbar [
	toolbar := BrToolbar new aptitude: BrGlamorousToolbarAptitude new
]

{ #category : #'private - announcement handling' }
GtLlmEmbeddedNewActionThreadMessageElement >> onThreadMessageContentsChanged: anAnnouncement [
	anAnnouncement requester = self ifTrue: [ ^ self ].
	self enqueueTask: (BlTaskAction new action: [ self updateElement ])
]

{ #category : #'private - hooks' }
GtLlmEmbeddedNewActionThreadMessageElement >> onThreadMessageViewModelChanged [
	self updateElement
]

{ #category : #'private - announcement handling' }
GtLlmEmbeddedNewActionThreadMessageElement >> onThreadMessageViewModelChanged: anAnnouncement [
	self enqueueTask: (BlTaskAction new action: [ self updateElement ])
]

{ #category : #'private - actions' }
GtLlmEmbeddedNewActionThreadMessageElement >> sendMessage [
	threadMessageViewModel ifNil: [ ^ self ].
	threadMessageViewModel currentAction hasArgument
		ifTrue: [ threadMessageViewModel contents: contentsElement text requester: self ].
	threadMessageViewModel sendMessage
]

{ #category : #'private - event handling' }
GtLlmEmbeddedNewActionThreadMessageElement >> sendMessageFrom: aButton [
	self sendMessage
]

{ #category : #'private - hooks' }
GtLlmEmbeddedNewActionThreadMessageElement >> subscribeToThreadMessageViewModel [
	self threadMessage
		when: GtLlmNewThreadMessageContentsChanged
		send: #onThreadMessageContentsChanged:
		to: self.
		
	self threadMessage assistantChat
		when: GtLlmThreadRunStartedAnnouncement
		send: #disableSend
		to: self.
		
	self threadMessage assistantChat
		when: GtLlmThreadRunIsDoneAnnouncement
		send: #enableSend
		to: self.

	self threadMessageViewModel weak
		when: GtLlmThreadMessageViewModelChanged
		send: #onThreadMessageViewModelChanged:
		to: self
]

{ #category : #'private - hooks' }
GtLlmEmbeddedNewActionThreadMessageElement >> unsubscribeFromThreadMessageViewModel [
	self threadMessage unsubscribe: self
]

{ #category : #'private - updating' }
GtLlmEmbeddedNewActionThreadMessageElement >> updateContents: aBlText [
	threadMessageViewModel ifNil: [ ^ self ].
	threadMessageViewModel contents: aBlText asString requester: self
]

{ #category : #'private - updating' }
GtLlmEmbeddedNewActionThreadMessageElement >> updateContentsElement [
	contentsElement styler: threadMessageViewModel styler
]

{ #category : #'private - updating' }
GtLlmEmbeddedNewActionThreadMessageElement >> updateElement [
	self updateToggleGroup.
	self updateContentsElement.
	self updateToolbar
]

{ #category : #'private - updating' }
GtLlmEmbeddedNewActionThreadMessageElement >> updateToggleGroup [
	toggleGroup removeToggles.
	self threadMessageViewModel actions
		do: [ :anAction | 
			| toggleElement |
			toggleElement := BrToggle new
					aptitude: BrGlamorousToggleWithLabelAptitude new;
					label: anAction name.
			toggleElement
				when: BrToggleActivatedEvent
				do: [ :anEvent | 
					descriptionElement text: anAction description.
					contentsElement
						text: '';
						visibility: (anAction hasArgument
								ifTrue: [ BlVisibility visible ]
								ifFalse: [ BlVisibility gone ]).
					self threadMessageViewModel currentAction: anAction ].
			toggleElement
				when: BlClickEvent
				do: [ :anEvent | anEvent modifiers isAlt ifTrue: [ toggleElement phlow spawnObject: anAction ] ].
			toggleGroup addToggle: toggleElement ].
	toggleGroup viewModel toggles
		ifNotEmpty: [ :aGroupOfToggles | aGroupOfToggles first activate ]
]

{ #category : #'private - updating' }
GtLlmEmbeddedNewActionThreadMessageElement >> updateToolbar [
	toolbar removeAllItems.
	toolbar addItem: self buildSendButton.
	toolbar addItem: self buildAttachButton.
	toolbar addItem: self buildProviderButton
]
