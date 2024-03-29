Class {
	#name : #GtOpenAIThreadMessageElement,
	#superclass : #BlElement,
	#traits : 'TGtOpenAIWithThreadMessageViewModel + TBrLayoutResizable',
	#classTraits : 'TGtOpenAIWithThreadMessageViewModel classTrait + TBrLayoutResizable classTrait',
	#instVars : [
		'senderElement',
		'contentsElement',
		'progressElement',
		'timeElement',
		'headerElement',
		'timeTask',
		'timeTooltip'
	],
	#category : #'Gt4OpenAI-Widgets'
}

{ #category : #factory }
GtOpenAIThreadMessageElement class >> newForChatList [
	^ self new
		geometry: (BlRoundedRectangleGeometry cornerRadius: 2);
		background: Color white;
		addAptitude: BrGlamorousFocusableShadowAptitude new;
		margin: (BlInsets
				top: 3
				bottom: 12
				left: 5
				right: 10)
]

{ #category : #accessing }
GtOpenAIThreadMessageElement >> contentsAptitudeDo: aBlock [
	aBlock value: contentsElement aptitude
]

{ #category : #accessing }
GtOpenAIThreadMessageElement >> contentsElementDo: aBlock [
	aBlock value: contentsElement
]

{ #category : #initialization }
GtOpenAIThreadMessageElement >> defaultLayout [
	^ BlLinearLayout vertical
]

{ #category : #'private - updating' }
GtOpenAIThreadMessageElement >> hideProgressElement [
	contentsElement visibility: BlVisibility visible.
	progressElement visibility: BlVisibility gone.
]

{ #category : #initialization }
GtOpenAIThreadMessageElement >> initialize [
	super initialize.
	self initializeHeaderElement.
	self initializeSenderElement.
	self initializeTimeElement.
	self initializeContentsElement.
	self initializeProgressElement.

	self addChild: headerElement as: #header.
	headerElement addChild: senderElement as: #sender.
	headerElement addChild: timeElement as: #time.
	self addChild: contentsElement as: #contents.
	self addChild: progressElement as: #progress.

	self hMatchParent.
	self vFitContentLimited.
	self padding: (BlInsets all: 3)
]

{ #category : #initialization }
GtOpenAIThreadMessageElement >> initializeContentsElement [
	contentsElement := BrEditor new
			padding: (BlInsets all: 2);
			hMatchParent;
			vFitContentLimited;
			aptitude: BrGlamorousRegularEditorAptitude;
			beReadOnlyWithSelection
]

{ #category : #initialization }
GtOpenAIThreadMessageElement >> initializeHeaderElement [
	headerElement := BrHorizontalPane new
			hFitContentLimited;
			vFitContent
]

{ #category : #initialization }
GtOpenAIThreadMessageElement >> initializeProgressElement [
	progressElement := BrLabel new
			fitContent;
			aptitude: (BrGlamorousLabelAptitude new
					foreground: BrGlamorousColors disabledButtonTextColor);
			beSmallSize;
			text: 'Typing...';
			visibility: BlVisibility gone
]

{ #category : #initialization }
GtOpenAIThreadMessageElement >> initializeSenderElement [
	senderElement := BrLabel new
			hFitContentLimited;
			vFitContent;
			aptitude: (BrGlamorousLabelAptitude new
					foreground: BrGlamorousColors disabledButtonTextColor);
			beSmallSize;
			text: ''
]

{ #category : #initialization }
GtOpenAIThreadMessageElement >> initializeTimeElement [
	timeTooltip := BrGlamorousWithLabelTooltipAptitude new text: 'unknown time'.
	timeElement := BrLabel new
			updatingDateAndTimeModel;
			fitContent;
			beSmallSize;
			aptitude: (BrGlamorousLabelAptitude new
					foreground: BrGlamorousColors disabledButtonTextColor);
			addAptitude: timeTooltip;
			text: ''
]

{ #category : #'private - announcement handling' }
GtOpenAIThreadMessageElement >> onRestyleRequested: anAnnouncement [
	self
		enqueueTask: (BlTaskAction new action: [ contentsElement editor styleText ])
]

{ #category : #'private - hooks' }
GtOpenAIThreadMessageElement >> onThreadMessageViewModelChanged [
	self updateElement
]

{ #category : #'private - announcement handling' }
GtOpenAIThreadMessageElement >> onThreadMessageViewModelChanged: anAnnouncement [
	self enqueueTask: (BlTaskAction new action: [ self updateElement ])
]

{ #category : #'private - updating' }
GtOpenAIThreadMessageElement >> showProgressElement [
	contentsElement visibility: BlVisibility gone.
	progressElement visibility: BlVisibility visible.
]

{ #category : #'private - hooks' }
GtOpenAIThreadMessageElement >> subscribeToThreadMessageViewModel [
	self threadMessageViewModel weak
		when: GtOpenAIThreadMessageRestyleRequested
			send: #onRestyleRequested:
			to: self;
		when: GtOpenAIThreadMessageViewModelChanged
			send: #onThreadMessageViewModelChanged:
			to: self
]

{ #category : #'private - updating' }
GtOpenAIThreadMessageElement >> updateContentsElement [
	contentsElement
		text: self threadMessageViewModel contentText;
		styler: self threadMessageViewModel styler
]

{ #category : #'private - updating' }
GtOpenAIThreadMessageElement >> updateElement [
	self updateSenderElement.
	self updateTimeElement.
	self updateContentsElement.
	self updateProgressElement.
	self updateFailureIndicator.
]

{ #category : #'private - updating' }
GtOpenAIThreadMessageElement >> updateFailureIndicator [
	self threadMessageViewModel isFailure
		ifTrue: [ self border: BrGlamorousColors errorBackgroundColor ]
		ifFalse: [ self border: BlBorder empty ]
]

{ #category : #'private - updating' }
GtOpenAIThreadMessageElement >> updateProgressElement [
	self threadMessage hasResponse
		ifTrue: [ self hideProgressElement ]
		ifFalse: [ self showProgressElement ]
]

{ #category : #'private - updating' }
GtOpenAIThreadMessageElement >> updateSenderElement [
	self threadMessage isAssistantRole
		ifTrue: [ senderElement text: 'ChatGPT' ]
		ifFalse: [ senderElement text: 'You' ]
]

{ #category : #'private - updating' }
GtOpenAIThreadMessageElement >> updateTimeElement [
	timeElement updatingDateAndTime: threadMessageViewModel createdAt.

	timeTooltip
		text: (String
				streamContents: [ :s | threadMessageViewModel createdAt asLocal printSeparateDateAndTimeOn: s ])
]
