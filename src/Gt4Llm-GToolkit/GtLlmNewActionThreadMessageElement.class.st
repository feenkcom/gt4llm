Class {
	#name : #GtLlmNewActionThreadMessageElement,
	#superclass : #BlElement,
	#traits : 'TBrLayoutResizable + TGtLlmWithThreadMessageViewModel',
	#classTraits : 'TBrLayoutResizable classTrait + TGtLlmWithThreadMessageViewModel classTrait',
	#instVars : [
		'contentsElement',
		'sendButton',
		'toolbar',
		'toggleGroup',
		'descriptionElement',
		'imagesElement'
	],
	#category : #'Gt4Llm-GToolkit'
}

{ #category : #factory }
GtLlmNewActionThreadMessageElement class >> newForChatList [
	^ self new
		geometry: (BlRoundedRectangleGeometry cornerRadius: 2);
		background: Color white;
		addAptitude: BrGlamorousFocusableShadowAptitude new;
		margin: (BlInsets
				top: 5
				bottom: 10
				left: 5
				right: 5)
]

{ #category : #'as yet unclassified' }
GtLlmNewActionThreadMessageElement >> buildAttachButton [
	^ BrButton new
		fitContent;
		beSmallSize;
		aptitude: BrGlamorousButtonWithIconAptitude new
				+ (BrGlamorousWithExplicitDropdownAptitude
						handle: [ BrButton new
								aptitude: BrGlamorousButtonWithIconAptitude - BrGlamorousButtonWithLabelTooltipAptitude2
										- BrGlamorousButtonExteriorAptitude;
								icon: BrGlamorousVectorIcons changes ]
						content: [ BrFileSelector new
								folder: FileLocator home;
								padding: (BlInsets all: 8);
								fileFilterBlock: [ :aFileReference | 
									aFileReference isFile
										and: [ (FileSystemDirectoryEntry reference: aFileReference) isHidden not ] ];
								okAction: [ :aFile :anOkButton | 
									self threadMessageViewModel attachFile: aFile.
									self updateImagesElement.
									anOkButton fireEvent: BrDropdownHideWish new ] ]);
		label: 'Attach';
		icon: BrGlamorousVectorIcons changes;
		margin: (BlInsets all: 3);
		constraintsDo: [ :c | 
			c linear vertical alignBottom.
			c linear horizontal alignLeft ]
]

{ #category : #'private - updating' }
GtLlmNewActionThreadMessageElement >> buildProviderButton [
	| aButton |
	^ aButton := BrButton new beSmallSize
			aptitude: BrGlamorousButtonWithLabelAptitude new
					+ (BrGlamorousWithExplicitDropdownAptitude
							handle: [ BrButton new beSmallSize
									aptitude: BrGlamorousButtonWithLabelAptitude - BrGlamorousButtonExteriorAptitude;
									label: self threadMessageViewModel connectionString ]
							content: [ | aList |
								aList := BrSimpleList new fitContent
										id: #'provider-list';
										items: self threadMessageViewModel connectionRegistry connectableConnections;
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
													provider: (self threadMessageViewModel connectionRegistry connections
															at: anEvent indices first) buildProvider.
												aButton label: self threadMessageViewModel connectionString.
												aList fireEvent: BrDropdownHideWish new ] ]);
			label: self threadMessageViewModel connectionString
]

{ #category : #'initialization ' }
GtLlmNewActionThreadMessageElement >> buildSendButton [
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
GtLlmNewActionThreadMessageElement >> defaultLayout [
	^ BlLinearLayout vertical
]

{ #category : #'as yet unclassified' }
GtLlmNewActionThreadMessageElement >> disableSend [
	sendButton disable
]

{ #category : #'as yet unclassified' }
GtLlmNewActionThreadMessageElement >> enableSend [
	sendButton enable
]

{ #category : #'initialization ' }
GtLlmNewActionThreadMessageElement >> initialize [
	super initialize.

	self initializeToggleGroup.
	self initializeDescriptionElement.
	self initializeContentsElement.
	self initializeToolbar.
	self initializeImagesElement.
	self
		addChild: (BrScrollPane new
				aptitude: BrScrollPaneAptitude;
				content: toggleGroup)
		as: #toggle.
	self addChild: descriptionElement as: #description.
	self addChild: contentsElement as: #contents.
	self addChild: imagesElement as: #images.
	self addChild: toolbar as: #toolbar.

	self hMatchParent.
	self vFitContentLimited
]

{ #category : #'initialization ' }
GtLlmNewActionThreadMessageElement >> initializeContentsElement [
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
GtLlmNewActionThreadMessageElement >> initializeDescriptionElement [
	descriptionElement := BrEditor new beReadOnlyWithoutSelection
			hMatchParent;
			vFitContentLimited;
			aptitude: (BrGlamorousRegularEditorAptitude new
					foreground: BrGlamorousColors disabledButtonTextColor)
]

{ #category : #'as yet unclassified' }
GtLlmNewActionThreadMessageElement >> initializeImagesElement [
	imagesElement := BrHorizontalPane new fitContent clipChildren: false
]

{ #category : #'initialization ' }
GtLlmNewActionThreadMessageElement >> initializeToggleGroup [
	toggleGroup := BrToggleGroup new
			aptitude: BrGlamorousToggleGroupAptitude new;
			margin: (BlInsets
					top: 3
					bottom: 0
					left: 8
					right: 8)
]

{ #category : #'initialization ' }
GtLlmNewActionThreadMessageElement >> initializeToolbar [
	toolbar := BrToolbar new aptitude: BrGlamorousToolbarAptitude new
]

{ #category : #'private - announcement handling' }
GtLlmNewActionThreadMessageElement >> onThreadMessageContentsChanged: anAnnouncement [
	anAnnouncement requester = self ifTrue: [ ^ self ].
	self enqueueTask: (BlTaskAction new action: [ self updateElement ])
]

{ #category : #'private - hooks' }
GtLlmNewActionThreadMessageElement >> onThreadMessageViewModelChanged [
	self updateElement
]

{ #category : #'private - announcement handling' }
GtLlmNewActionThreadMessageElement >> onThreadMessageViewModelChanged: anAnnouncement [
	self enqueueTask: (BlTaskAction new action: [ self updateElement ])
]

{ #category : #'private - actions' }
GtLlmNewActionThreadMessageElement >> sendMessage [
	threadMessageViewModel ifNil: [ ^ self ].
	threadMessageViewModel currentAction hasArgument
		ifTrue: [ threadMessageViewModel contents: contentsElement text requester: self ].
	threadMessageViewModel sendMessage
]

{ #category : #'private - event handling' }
GtLlmNewActionThreadMessageElement >> sendMessageFrom: aButton [
	self sendMessage
]

{ #category : #'private - hooks' }
GtLlmNewActionThreadMessageElement >> subscribeToThreadMessageViewModel [
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
GtLlmNewActionThreadMessageElement >> unsubscribeFromThreadMessageViewModel [
	self threadMessage unsubscribe: self
]

{ #category : #'private - updating' }
GtLlmNewActionThreadMessageElement >> updateContents: aBlText [
	threadMessageViewModel ifNil: [ ^ self ].
	threadMessageViewModel contents: aBlText asString requester: self
]

{ #category : #'private - updating' }
GtLlmNewActionThreadMessageElement >> updateContentsElement [
	contentsElement styler: threadMessageViewModel styler
]

{ #category : #'private - updating' }
GtLlmNewActionThreadMessageElement >> updateElement [
	self updateToggleGroup.
	self updateContentsElement.
	self updateToolbar.
	self updateImagesElement
]

{ #category : #'as yet unclassified' }
GtLlmNewActionThreadMessageElement >> updateImagesElement [
	imagesElement removeChildren.

	self threadMessageViewModel files
		do: [ :aFile | 
			imagesElement
				addChild: (BrDeletableFileWidget new
						vExact: 100;
						hExact: 100;
						isDeletable: true;
						file: aFile;
						onDeletion: [ :aFileForDeletion | 
							self threadMessageViewModel files remove: aFileForDeletion.
							self updateImagesElement ]) ]
]

{ #category : #'private - updating' }
GtLlmNewActionThreadMessageElement >> updateToggleGroup [
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
GtLlmNewActionThreadMessageElement >> updateToolbar [
	toolbar removeAllItems.
	toolbar addItem: self buildSendButton.
	toolbar addItem: self buildAttachButton.
	toolbar addItem: self buildProviderButton
]
