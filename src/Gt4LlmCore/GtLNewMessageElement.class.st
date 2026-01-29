Class {
	#name : #GtLNewMessageElement,
	#superclass : #BlElement,
	#traits : 'TBrLayoutResizable + TGtLWithMessageViewModel',
	#classTraits : 'TBrLayoutResizable classTrait + TGtLWithMessageViewModel classTrait',
	#instVars : [
		'contentsElement',
		'toolbar',
		'imagesElement',
		'sendButton',
		'senderFuture',
		'stopButton'
	],
	#category : #'Gt4LlmCore-UI - Elements'
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
	aButton := BrButton new.
	aButton
		beSmallSize;
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
		label: self messageViewModel connectionString.
	^ aButton
]

{ #category : #'private - updating' }
GtLNewMessageElement >> buildProviderStopButton [
	stopButton := BrButton new.
	stopButton
		id: #'chat--stop';
		beSmallSize;
		aptitude: BrGlamorousButtonWithIconAptitude new;
		icon: BrGlamorousVectorIcons stop;
		label: 'Stop ongoing execution';
		action: [ :theButton | self onStopOngoingExecution ];
		visibility: BlVisibility gone.
	^ stopButton
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
	self initializeSenderFuture.
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
GtLNewMessageElement >> initializeSenderFuture [
	senderFuture := (BrAsyncElementFuture on: self)
			executionConfiguration: GtLSettings futureExecutionConfiguration;
			whenPending: [ :anElement | self disableSend ];
			whenError: [ :anElement :anError | self updateSendMessageError: anError ];
			whenSuccess: [ :anElement :anObject | self enableSend ]
]

{ #category : #'initialization ' }
GtLNewMessageElement >> initializeToolbar [
	toolbar := BrToolbar new aptitude: BrGlamorousToolbarAptitude new
]

{ #category : #'private - testing' }
GtLNewMessageElement >> isChatProviderRunning [
	self messageViewModel ifNil: [ ^ false ].
	^ self messageViewModel chat state ifCanStop: [ true ] ifIdle: [ false ]
]

{ #category : #'private - announcement handling' }
GtLNewMessageElement >> onChatExecutionStateChanged: anAnnouncement [
	self enqueueTask: (BlTaskAction new action: [ self updateStopButton ])
]

{ #category : #'private - hooks' }
GtLNewMessageElement >> onMessageViewModelChanged [
	self updateElement
]

{ #category : #'private - announcement handling' }
GtLNewMessageElement >> onMessageViewModelContentsChanged: anAnnouncement [
	anAnnouncement source = self ifTrue: [ ^ self ].
	self enqueueTask: (BlTaskAction new action: [ self updateElement ])
]

{ #category : #'private - event handling' }
GtLNewMessageElement >> onStopOngoingExecution [
	self messageViewModel ifNil: [ ^ self ].
	self messageViewModel chat stopOngoingExecution
]

{ #category : #'private - announcement handling' }
GtLNewMessageElement >> onThreadMessageViewModelChanged: anAnnouncement [
	self enqueueTask: (BlTaskAction new action: [ self updateElement ])
]

{ #category : #'private - actions' }
GtLNewMessageElement >> sendMessage [
	self messageViewModel ifNil: [ ^ self ].
	senderFuture future: self messageViewModel sendMessage
]

{ #category : #'private - event handling' }
GtLNewMessageElement >> sendMessageFrom: aButton [
	self sendMessage
]

{ #category : #'private - hooks' }
GtLNewMessageElement >> subscribeToMessageViewModel [
	self messageViewModel chat
		when: GtLlmThreadRunStartedAnnouncement
			send: #disableSend
			to: self;
		when: GtLlmThreadRunIsDoneAnnouncement
			send: #enableSend
			to: self;
		when: GtLChatExecutionStateChanged
			send: #onChatExecutionStateChanged:
			to: self.

	self messageViewModel weak
		when: GtLMessageViewModelContentsChanged
			send: #onMessageViewModelContentsChanged:
			to: self;
		when: GtLlmThreadMessageViewModelChanged
			send: #onThreadMessageViewModelChanged:
			to: self
]

{ #category : #'private - hooks' }
GtLNewMessageElement >> unsubscribeFromMessageViewModel [
	self messageViewModel chat unsubscribe: self.
	self messageViewModel unsubscribe: self
]

{ #category : #'private - updating' }
GtLNewMessageElement >> updateContents: aBlText [
	messageViewModel ifNil: [ ^ self ].
	messageViewModel contents: aBlText asString source: self
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
	self updateToolbar.
	self updateStopButton
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

{ #category : #'private - event handling' }
GtLNewMessageElement >> updateSendMessageError: anError [ 
	| anErrorCopy |
	anErrorCopy := GtSystemUtility freeze: anError.
	anErrorCopy inspect.
]

{ #category : #'private - updating' }
GtLNewMessageElement >> updateStopButton [
	stopButton
		visibility: (self isChatProviderRunning
				ifTrue: [ BlVisibility visible ]
				ifFalse: [ BlVisibility gone ])
]

{ #category : #'private - updating' }
GtLNewMessageElement >> updateToolbar [
	toolbar removeAllItems.
	toolbar addItem: self buildSendButton.
	toolbar addItem: self buildAttachButton.
	toolbar addItem: self buildProviderButton.
	toolbar addItem: self buildProviderStopButton
]
