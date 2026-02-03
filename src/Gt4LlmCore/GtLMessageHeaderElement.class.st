Class {
	#name : #GtLMessageHeaderElement,
	#superclass : #GtLBasicMessageElement,
	#instVars : [
		'senderElement',
		'contentElement',
		'contentLabelElement',
		'senderTooltipAptitude',
		'executionStateLabelElement',
		'toolbarElement'
	],
	#category : 'Gt4LlmCore-UI - Elements'
}

{ #category : #initialization }
GtLMessageHeaderElement >> defaultLayout [
	^ BlLinearLayout horizontal
]

{ #category : #'api - visibility' }
GtLMessageHeaderElement >> hideToolbarElement [
	^ toolbarElement visibility: BlVisibility hidden
]

{ #category : #initialization }
GtLMessageHeaderElement >> initialize [
	super initialize.
	
	self initializeSenderElement.
	self initializeContentElement.
	self initializeToolbarElement.
	self initializeEventListeners.
	
	self addChild: senderElement as: #'chat--message-sender'.
	self addChild: contentElement.
	self addChild: toolbarElement as: #'chat--message-toolbar'.
	
	self vFitContent.
	self hMatchParent
]

{ #category : #initialization }
GtLMessageHeaderElement >> initializeContentElement [
	contentElement := BrHorizontalPane new
			hMatchParent;
			vFitContent;
			padding: (BlInsets left: 0 right: 15);
			addChild: (contentLabelElement := BrLabel new
						id: #'chat--message-content';
						hFitContentLimited;
						vFitContent;
						aptitude: BrGlamorousLabelAptitude new;
						beSmallSize);
			addChild: (executionStateLabelElement := BrLabel new
						id: #'chat--message-state';
						hFitContent;
						vFitContent;
						aptitude: (BrGlamorousLabelAptitude new foreground: self theme button disabledTextColor);
						beSmallSize)
]

{ #category : #initialization }
GtLMessageHeaderElement >> initializeEventListeners [
	self when: GtLShowToolbarWish do: [ :anEvent | self showToolbarElement ].
	self when: GtLHideToolbarWish do: [ :anEvent | self hideToolbarElement ]
]

{ #category : #initialization }
GtLMessageHeaderElement >> initializeSenderElement [
	senderElement := BrLabel new
			hFitContent;
			vFitContent;
			aptitude: (BrGlamorousLabelAptitude new
					foreground: BrGlamorousColors disabledButtonTextColor);
			beSmallSize;
			addAptitude: (senderTooltipAptitude := BrGlamorousWithExplicitTooltipAptitude new)
]

{ #category : #initialization }
GtLMessageHeaderElement >> initializeToolbarElement [
	toolbarElement := GtLActionToolbarMessageElement new fitContent
]

{ #category : #'private - hooks' }
GtLMessageHeaderElement >> onMessageViewModelChanged [
	toolbarElement messageViewModel: self messageViewModel.
	self updateElement
]

{ #category : #'private - event handling' }
GtLMessageHeaderElement >> onMessageViewModelContentsChanged: anAnnouncement [
	BlTaskAction enqueueElement: self action: [ self updateElement ]
]

{ #category : #'private - event handling' }
GtLMessageHeaderElement >> onMessageViewModelExecutionChangedChanged: anAnnouncement [
	self messageViewModel = anAnnouncement messageViewModel ifFalse: [ ^ self ].

	BlTaskAction enqueueElement: self action: [ self updateExecutionStateElement ]
]

{ #category : #'private - event handling' }
GtLMessageHeaderElement >> onThreadMessageViewModelChanged: anAnnouncement [
	BlTaskAction enqueueElement: self action: [ self updateElement ]
]

{ #category : #'api - visibility' }
GtLMessageHeaderElement >> showToolbarElement [
	^ toolbarElement visibility: BlVisibility visible
]

{ #category : #'private - hooks' }
GtLMessageHeaderElement >> subscribeToMessageViewModel [
	self messageViewModel weak
		when: GtLlmThreadMessageViewModelChanged
			send: #onThreadMessageViewModelChanged:
			to: self;
		when: GtLMessageViewModelContentsChanged
			send: #onMessageViewModelContentsChanged:
			to: self;
		when: GtLMessageViewModelExecutionStateChanged
			send: #onMessageViewModelExecutionChangedChanged:
			to: self
]

{ #category : #'private - hooks' }
GtLMessageHeaderElement >> unsubscribeFromMessageViewModel [
	self messageViewModel unsubscribe: self
]

{ #category : #'private - updating' }
GtLMessageHeaderElement >> updateContentElement [
	contentLabelElement text: self messageViewModel contentText
]

{ #category : #'private - updating' }
GtLMessageHeaderElement >> updateElement [
	self updateSenderElement.
	self updateContentElement.
	self updateExecutionStateElement.
]

{ #category : #'private - updating' }
GtLMessageHeaderElement >> updateExecutionStateElement [
	executionStateLabelElement text: self messageViewModel messageExecutionStateLabel
]

{ #category : #'private - updating' }
GtLMessageHeaderElement >> updateSenderElement [
	senderElement text: self messageViewModel senderText.
	senderTooltipAptitude
		text: (String
				streamContents: [ :s | self messageViewModel createdAt asLocal printSeparateDateAndTimeOn: s ])
]
