Class {
	#name : #GtLNewMessageElement,
	#superclass : #BlElement,
	#traits : 'TBrLayoutResizable + TGtLWithMessageViewModel',
	#classTraits : 'TBrLayoutResizable classTrait + TGtLWithMessageViewModel classTrait',
	#instVars : [
		'contentsElement',
		'imagesElement',
		'sendButton',
		'stopButton',
		'senderPromise',
		'attachButton',
		'connectionsButton',
		'toolbarElement'
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

{ #category : #initialization }
GtLNewMessageElement >> defaultLayout [
	^ BlLinearLayout vertical
]

{ #category : #'private - updating' }
GtLNewMessageElement >> disableSend [
	sendButton disable
]

{ #category : #'private - updating' }
GtLNewMessageElement >> enableSend [
	sendButton enable
]

{ #category : #'initialization ' }
GtLNewMessageElement >> initialize [
	super initialize.

	self initializeContentsElement.
	self initializeImagesElement.
	self initializeToolbarElement.
	self initializeSenderElementPromise.
	self initializeSendButtonElement.
	self initializeStopButtonElement.
	self initializeAttachButtonElement.
	self initializeConnectionsButtonElement.

	toolbarElement addChild: sendButton as: #'chat--send'.
	toolbarElement addChild: stopButton as: #'chat--stop'.
	toolbarElement addChild: attachButton as: #'chat--attach'.
	toolbarElement addChild: connectionsButton as: #'chat--connections'.

	self addChild: contentsElement as: #contents.
	self addChild: imagesElement as: #images.
	self addChild: toolbarElement as: #toolbar.

	self hMatchParent.
	self vFitContentLimited
]

{ #category : #'initialization ' }
GtLNewMessageElement >> initializeAttachButtonElement [
	attachButton := BrButton new
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
										self messageViewModel attachFile: aFile.
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
GtLNewMessageElement >> initializeConnectionsButtonElement [
	connectionsButton := BrButton new.
	connectionsButton
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
											self messageViewModel
												provider: (self messageViewModel connectionRegistry connectableConnections
														at: anEvent indices first) buildProvider.
											connectionsButton label: self messageViewModel connectionString.
											aList fireEvent: BrDropdownHideWish new ] ]);
		label: ''
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
				performBlock: [ :aBrTextEditor | self sendMessageFrom: aBrTextEditor ];
				yourself)
]

{ #category : #'initialization ' }
GtLNewMessageElement >> initializeImagesElement [
	imagesElement := BrHorizontalPane new fitContent clipChildren: false
]

{ #category : #'initialization ' }
GtLNewMessageElement >> initializeSendButtonElement [
	sendButton := BrButton new
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

{ #category : #'initialization ' }
GtLNewMessageElement >> initializeSenderElementPromise [
	senderPromise := (BrAsyncElementPromise on: self)
			whenPending: [ :anElement | self disableSend ];
			whenError: [ :anElement :anError | self updateSendMessageError: anError ];
			whenSuccess: [ :anElement :anObject | self enableSend ]
]

{ #category : #initialization }
GtLNewMessageElement >> initializeStopButtonElement [
	stopButton := BrButton new
			beSmallSize;
			aptitude: BrGlamorousButtonWithIconAptitude new;
			icon: BrGlamorousVectorIcons stop;
			label: 'Stop ongoing execution';
			action: [ :theButton | self onStopOngoingExecution ];
			visibility: BlVisibility gone
]

{ #category : #'initialization ' }
GtLNewMessageElement >> initializeToolbarElement [
	toolbarElement := BrToolbar new aptitude: BrGlamorousToolbarAptitude new
]

{ #category : #'private - announcement handling' }
GtLNewMessageElement >> onChatExecutionStateChanged: anAnnouncement [
	self
		enqueueTask: (BlTaskAction new
				action: [ 
					self updateSendButton.
					self updateStopButton ])
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

{ #category : #'private - event handling' }
GtLNewMessageElement >> sendMessageFrom: anElement [
	self messageViewModel ifNil: [ ^ self ].
	senderPromise promise: self messageViewModel sendMessage
]

{ #category : #'private - hooks' }
GtLNewMessageElement >> subscribeToMessageViewModel [
	self messageViewModel chat
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
GtLNewMessageElement >> updateConnectionsButton [
	connectionsButton label: self messageViewModel connectionString
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
	self updateStopButton.
	self updateSendButton.
	self updateConnectionsButton
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
GtLNewMessageElement >> updateSendButton [
	self messageViewModel ifNil: [ ^ self ].
	self messageViewModel chat ifNil: [ ^ self ].
	self messageViewModel chat state
		ifCanStop: [ sendButton
				disable;
				visibility: BlVisibility gone ]
		ifStopping: [ sendButton
				disable;
				visibility: BlVisibility gone ]
		ifIdle: [ sendButton
				enable;
				visibility: BlVisibility visible ]
]

{ #category : #'private - event handling' }
GtLNewMessageElement >> updateSendMessageError: anError [ 
	| anErrorCopy |
	anErrorCopy := GtSystemUtility freeze: anError.
	anErrorCopy inspect.
]

{ #category : #'private - updating' }
GtLNewMessageElement >> updateStopButton [
	self messageViewModel ifNil: [ ^ self ].
	self messageViewModel chat ifNil: [ ^ self ].
	self messageViewModel chat state
		ifCanStop: [ stopButton
				visibility: BlVisibility visible;
				enable ]
		ifStopping: [ stopButton
				visibility: BlVisibility visible;
				disable ]
		ifIdle: [ stopButton
				visibility: BlVisibility gone;
				disable ]
]
