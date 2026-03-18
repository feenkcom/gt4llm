"
I render a compact message header focused on sender and date, together with contextual actions.

## Example
{{gtExample:GtLChatOpenAIElementExamples>>#messageSenderAndDateHeaderElement|noCode|previewExpanded}}
"
Class {
	#name : #GtLMessageSenderAndDateHeaderElement,
	#superclass : #GtLBasicMessageElement,
	#instVars : [
		'senderElement',
		'toolbarElement',
		'dateElement'
	],
	#category : #'Gt4LlmCore-UI - Elements'
}

{ #category : #initialization }
GtLMessageSenderAndDateHeaderElement >> defaultLayout [
	^ BlLinearLayout horizontal alignCenterLeft
]

{ #category : #initialization }
GtLMessageSenderAndDateHeaderElement >> hideToolbarElement [
	toolbarElement visibility: BlVisibility hidden.
	dateElement visibility: BlVisibility hidden
]

{ #category : #initialization }
GtLMessageSenderAndDateHeaderElement >> initialize [
	super initialize.

	self initializeSenderElement.
	self initializeDateElement.
	self initializeToolbarElement.
	self initializeEventListeners.

	self addChild: senderElement as: #'chat--message-sender'.
	self addChild: dateElement as: #'chat--message-date'.
	self
		addChild: (BrFrame new
				vExact: 0;
				hMatchParent).
	self addChild: toolbarElement as: #'chat--message-toolbar'.

	self vFitContent.
	self hMatchParent
]

{ #category : #initialization }
GtLMessageSenderAndDateHeaderElement >> initializeDateElement [
	dateElement := BrLabel new
			aptitude: (BrGlamorousLabelAptitude new
					foreground: BrGlamorousColors disabledButtonTextColor);
			fitContent;
			constraintsDo: [ :c | c linear vertical alignTop ];
			margin: (BlInsets left: 10 right: 10)
]

{ #category : #initialization }
GtLMessageSenderAndDateHeaderElement >> initializeEventListeners [
	self when: GtLShowToolbarWish do: [ :anEvent | self showToolbarElement ].
	self when: GtLHideToolbarWish do: [ :anEvent | self hideToolbarElement ]
]

{ #category : #initialization }
GtLMessageSenderAndDateHeaderElement >> initializeSenderElement [
	senderElement := BrLabel new
			alignTopLeft;
			hFitContent;
			vFitContent;
			background: self theme default backdropBackground;
			geometry: (BlRoundedRectangleGeometry cornerRadius: 2);
			aptitude: BrGlamorousLabelAptitude new;
			constraintsDo: [ :c | c linear vertical alignTop ];
			padding: (BlInsets left: 2 right: 2)
]

{ #category : #initialization }
GtLMessageSenderAndDateHeaderElement >> initializeToolbarElement [
	toolbarElement := GtLActionToolbarMessageElement new fitContent
]

{ #category : #'private - hooks' }
GtLMessageSenderAndDateHeaderElement >> onMessageViewModelChanged [
	toolbarElement messageViewModel: self messageViewModel.
	self updateElement
]

{ #category : #'private - event handling' }
GtLMessageSenderAndDateHeaderElement >> onMessageViewModelContentsChanged: anAnnouncement [
	BlTaskAction enqueueElement: self action: [ self updateElement ]
]

{ #category : #'private - event handling' }
GtLMessageSenderAndDateHeaderElement >> onMessageViewModelExecutionChangedChanged: anAnnouncement [
	self messageViewModel = anAnnouncement messageViewModel ifFalse: [ ^ self ].

	BlTaskAction enqueueElement: self action: [ self updateDateElement ]
]

{ #category : #'private - event handling' }
GtLMessageSenderAndDateHeaderElement >> onThreadMessageViewModelChanged: anAnnouncement [
	BlTaskAction enqueueElement: self action: [ self updateElement ]
]

{ #category : #initialization }
GtLMessageSenderAndDateHeaderElement >> showToolbarElement [
	toolbarElement visibility: BlVisibility visible.
	dateElement visibility: BlVisibility visible
]

{ #category : #'private - hooks' }
GtLMessageSenderAndDateHeaderElement >> subscribeToMessageViewModel [
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
GtLMessageSenderAndDateHeaderElement >> unsubscribeFromMessageViewModel [
	self messageViewModel unsubscribe: self
]

{ #category : #'private - updating' }
GtLMessageSenderAndDateHeaderElement >> updateDateElement [
	dateElement text: self messageViewModel dateString
]

{ #category : #'private - updating' }
GtLMessageSenderAndDateHeaderElement >> updateElement [
	self updateSenderElement.
	self updateDateElement.
]

{ #category : #'private - updating' }
GtLMessageSenderAndDateHeaderElement >> updateSenderElement [
	senderElement text: self messageViewModel senderText2
]
