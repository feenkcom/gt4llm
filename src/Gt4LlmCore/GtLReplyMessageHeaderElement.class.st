Class {
	#name : #GtLReplyMessageHeaderElement,
	#superclass : #GtLBasicMessageElement,
	#instVars : [
		'senderElement',
		'toolbarElement',
		'dateElement',
		'executionStateElement'
	],
	#category : #'Gt4LlmCore-UI - Elements'
}

{ #category : #initialization }
GtLReplyMessageHeaderElement >> defaultLayout [
	^ BlLinearLayout horizontal alignTopLeft
]

{ #category : #'api - visibility' }
GtLReplyMessageHeaderElement >> hideToolbarElement [
	^ toolbarElement visibility: BlVisibility hidden
]

{ #category : #initialization }
GtLReplyMessageHeaderElement >> initialize [
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
GtLReplyMessageHeaderElement >> initializeDateElement [
	dateElement := BrLabel new
			aptitude: (BrGlamorousLabelAptitude new
					foreground: BrGlamorousColors disabledButtonTextColor);
			fitContent;
			constraintsDo: [ :c | c linear vertical alignTop ];
			padding: (BlInsets left: 0 right: 15)
]

{ #category : #initialization }
GtLReplyMessageHeaderElement >> initializeEventListeners [
	self when: GtLShowToolbarWish do: [ :anEvent | self showToolbarElement ].
	self when: GtLHideToolbarWish do: [ :anEvent | self hideToolbarElement ]
]

{ #category : #initialization }
GtLReplyMessageHeaderElement >> initializeSenderElement [
	senderElement := BrLabel new
			alignTopLeft;
			hFitContent;
			vFitContent;
			aptitude: (BrGlamorousLabelAptitude new
					foreground: BrGlamorousColors disabledButtonTextColor);
			constraintsDo: [ :c | c linear vertical alignTop ]
]

{ #category : #initialization }
GtLReplyMessageHeaderElement >> initializeToolbarElement [
	toolbarElement := GtLActionToolbarMessageElement new fitContent
]

{ #category : #'private - hooks' }
GtLReplyMessageHeaderElement >> onMessageViewModelChanged [
	toolbarElement messageViewModel: self messageViewModel.
	self updateElement
]

{ #category : #'private - event handling' }
GtLReplyMessageHeaderElement >> onMessageViewModelContentsChanged: anAnnouncement [
	BlTaskAction enqueueElement: self action: [ self updateElement ]
]

{ #category : #'private - event handling' }
GtLReplyMessageHeaderElement >> onMessageViewModelExecutionChangedChanged: anAnnouncement [
	self messageViewModel = anAnnouncement messageViewModel ifFalse: [ ^ self ].

	BlTaskAction enqueueElement: self action: [ self updateDateElement ]
]

{ #category : #'private - event handling' }
GtLReplyMessageHeaderElement >> onThreadMessageViewModelChanged: anAnnouncement [
	BlTaskAction enqueueElement: self action: [ self updateElement ]
]

{ #category : #'api - visibility' }
GtLReplyMessageHeaderElement >> showToolbarElement [
	^ toolbarElement visibility: BlVisibility visible
]

{ #category : #'private - hooks' }
GtLReplyMessageHeaderElement >> subscribeToMessageViewModel [
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
GtLReplyMessageHeaderElement >> unsubscribeFromMessageViewModel [
	self messageViewModel unsubscribe: self
]

{ #category : #'private - updating' }
GtLReplyMessageHeaderElement >> updateDateElement [
	| dateAndTime text |
	self messageViewModel finalMessageViewModel ifNil: [ ^ dateElement text: 'running' ].
	
	dateAndTime := self messageViewModel createdAt asLocal.

	text := String
			streamContents: [ :aStream | 
				dateAndTime asDate printOn: aStream format: #(2 1 3 $  3 1 1).
				aStream space.
				dateAndTime hour
					printOn: aStream
					base: 10
					length: 2
					padded: true.
				aStream nextPut: $:.
				dateAndTime minute
					printOn: aStream
					base: 10
					length: 2
					padded: true ].

	dateElement text: text
]

{ #category : #'private - updating' }
GtLReplyMessageHeaderElement >> updateElement [
	self updateSenderElement.
	self updateDateElement.
]

{ #category : #'private - updating' }
GtLReplyMessageHeaderElement >> updateSenderElement [
	senderElement text: self messageViewModel senderText
]
