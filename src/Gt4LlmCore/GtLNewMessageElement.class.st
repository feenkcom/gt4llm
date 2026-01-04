Class {
	#name : #GtLNewMessageElement,
	#superclass : #BlElement,
	#traits : 'TBrLayoutResizable + TGtLWithChatMessageViewModel',
	#classTraits : 'TBrLayoutResizable classTrait + TGtLWithChatMessageViewModel classTrait',
	#instVars : [
		'contentsElement',
		'toolbar',
		'imagesElement',
		'sendButton'
	],
	#category : #'Gt4LlmCore-UI'
}

{ #category : #factory }
GtLNewMessageElement class >> newForChatList [
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

{ #category : #'initialization ' }
GtLNewMessageElement >> buildAttachButton [
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

{ #category : #'as yet unclassified' }
GtLNewMessageElement >> buildProviderButton [
	| aButton |
	^ aButton := BrButton new beSmallSize
			aptitude: BrGlamorousButtonWithLabelAptitude new
					+ (BrGlamorousWithExplicitDropdownAptitude
							handle: [ BrButton new beSmallSize
									aptitude: BrGlamorousButtonWithLabelAptitude - BrGlamorousButtonExteriorAptitude;
									label: self messageViewModel connectionString ]
							content: [ | aList |
								aList := BrSimpleList new fitContent
										id: #'provider-list';
										items: self messageViewModel connectionRegistry connectableConnections;
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
													provider: (self threadMessageViewModel connectionRegistry connectableConnections
															at: anEvent indices first) buildProvider.
												aButton label: self threadMessageViewModel connectionString.
												aList fireEvent: BrDropdownHideWish new ] ]);
			label: self messageViewModel connectionString
]

{ #category : #'initialization ' }
GtLNewMessageElement >> buildSendButton [
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
GtLNewMessageElement >> defaultLayout [
	^ BlLinearLayout vertical
]

{ #category : #'as yet unclassified' }
GtLNewMessageElement >> disableSend [
	sendButton disable
]

{ #category : #'as yet unclassified' }
GtLNewMessageElement >> enableSend [
	sendButton enable
]

{ #category : #'initialization ' }
GtLNewMessageElement >> initialize [
	super initialize.

	self initializeContentsElement.
	self initializeImagesElement.
	self initializeToolbar.
	self addChild: contentsElement as: #contents.
	self addChild: imagesElement as: #images.
	self addChild: toolbar as: #toolbar.

	self hMatchParent.
	self vFitContentLimited
]

{ #category : #'initialization ' }
GtLNewMessageElement >> initializeContentsElement [
	contentsElement := BrEditor new
			hMatchParent;
			vFitContentLimited;
			aptitude: BrGlamorousRegularEditorAptitude.

	contentsElement editor
		when: BrTextEditorModifiedEvent
		do: [ :anEvent | self updateContents: anEvent text ].

	contentsElement
		addShortcut: (BrEditorShortcut new
				name: 'Send message';
				description: 'Send message to the OpenAI assistant chat';
				combination: BlKeyCombination primaryReturn;
				performBlock: [ :aBrTextEditor | self sendMessage ];
				yourself)
]

{ #category : #'initialization ' }
GtLNewMessageElement >> initializeImagesElement [
	imagesElement := BrHorizontalPane new fitContent clipChildren: false
]

{ #category : #'initialization ' }
GtLNewMessageElement >> initializeToolbar [
	toolbar := BrToolbar new aptitude: BrGlamorousToolbarAptitude new
]

{ #category : #'private - hooks' }
GtLNewMessageElement >> onMessageViewModelChanged [
	self updateElement
]

{ #category : #'private - announcement handling' }
GtLNewMessageElement >> onThreadMessageContentsChanged: anAnnouncement [
	anAnnouncement requester = self ifTrue: [ ^ self ].
	self enqueueTask: (BlTaskAction new action: [ self updateElement ])
]

{ #category : #'private - announcement handling' }
GtLNewMessageElement >> onThreadMessageViewModelChanged: anAnnouncement [
	self enqueueTask: (BlTaskAction new action: [ self updateElement ])
]

{ #category : #'private - actions' }
GtLNewMessageElement >> sendMessage [
	messageViewModel ifNil: [ ^ self ].
	messageViewModel sendMessage
]

{ #category : #'private - event handling' }
GtLNewMessageElement >> sendMessageFrom: aButton [
	self sendMessage
]

{ #category : #'private - hooks' }
GtLNewMessageElement >> subscribeToMessageViewModel [
	self message
		when: GtLlmNewThreadMessageContentsChanged
		send: #onThreadMessageContentsChanged:
		to: self.

	self message assistantChat
		when: GtLlmThreadRunStartedAnnouncement
		send: #disableSend
		to: self.

	self message assistantChat
		when: GtLlmThreadRunIsDoneAnnouncement
		send: #enableSend
		to: self.

	self messageViewModel weak
		when: GtLlmThreadMessageViewModelChanged
		send: #onThreadMessageViewModelChanged:
		to: self
]

{ #category : #'private - hooks' }
GtLNewMessageElement >> unsubscribeFromMessageViewModel [
	self message unsubscribe: self.
	self message assistantChat unsubscribe: self.
	self messageViewModel unsubscribe: self
]

{ #category : #'private - updating' }
GtLNewMessageElement >> updateContents: aBlText [
	messageViewModel ifNil: [ ^ self ].
	messageViewModel contents: aBlText asString requester: self
]

{ #category : #'private - updating' }
GtLNewMessageElement >> updateContentsElement [
	contentsElement
		text: messageViewModel contents;
		styler: messageViewModel styler
]

{ #category : #'private - updating' }
GtLNewMessageElement >> updateElement [
	self updateContentsElement.
	self updateImagesElement.
	self updateToolbar
]

{ #category : #'private - updating' }
GtLNewMessageElement >> updateImagesElement [
	imagesElement removeChildren.

	self messageViewModel files
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
GtLNewMessageElement >> updateToolbar [
	toolbar removeAllItems.
	toolbar addItem: self buildSendButton.
	toolbar addItem: self buildAttachButton.
	toolbar addItem: self buildProviderButton
]
