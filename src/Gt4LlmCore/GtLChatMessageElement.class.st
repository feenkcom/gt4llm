Class {
	#name : #GtLChatMessageElement,
	#superclass : #BlElement,
	#traits : 'TGtLWithChatMessageViewModel + TBrLayoutResizable',
	#classTraits : 'TGtLWithChatMessageViewModel classTrait + TBrLayoutResizable classTrait',
	#instVars : [
		'contentsElement',
		'progressElement',
		'timeTooltip'
	],
	#category : #'Gt4LlmCore-UI'
}

{ #category : #factory }
GtLChatMessageElement class >> newForChatList [
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

{ #category : #accessing }
GtLChatMessageElement >> contentsAptitudeDo: aBlock [
	aBlock value: contentsElement aptitude
]

{ #category : #accessing }
GtLChatMessageElement >> contentsElementDo: aBlock [
	aBlock value: contentsElement
]

{ #category : #initialization }
GtLChatMessageElement >> defaultLayout [
	^ BlLinearLayout vertical
]

{ #category : #'private - updating' }
GtLChatMessageElement >> hideProgressElement [
	contentsElement visibility: BlVisibility visible.
	progressElement visibility: BlVisibility gone.
]

{ #category : #initialization }
GtLChatMessageElement >> initialize [
	super initialize.
	self initializeContentsElement.
	self initializeProgressElement.

	self addChild: contentsElement as: #contents.
	self addChild: progressElement as: #progress.

	self hMatchParent.
	self vFitContentLimited.
	self padding: (BlInsets all: 3)
]

{ #category : #initialization }
GtLChatMessageElement >> initializeContentsElement [
	contentsElement := BrEditor new
			padding: (BlInsets all: 2);
			hMatchParent;
			vFitContentLimited;
			aptitude: BrGlamorousRegularEditorAptitude;
			beReadOnlyWithSelection
]

{ #category : #initialization }
GtLChatMessageElement >> initializeProgressElement [
	progressElement := BrLabel new
			fitContent;
			aptitude: (BrGlamorousLabelAptitude new
					foreground: BrGlamorousColors disabledButtonTextColor);
			beSmallSize;
			text: 'Typing...';
			visibility: BlVisibility gone
]

{ #category : #'private - announcement handling' }
GtLChatMessageElement >> onMessageContentsChanged: anAnnouncement [
	self enqueueTask: (BlTaskAction new action: [ self updateContentsElement ])
]

{ #category : #'private - hooks' }
GtLChatMessageElement >> onMessageViewModelChanged [
	self updateElement
]

{ #category : #'private - announcement handling' }
GtLChatMessageElement >> onRestyleRequested: anAnnouncement [
	self
		enqueueTask: (BlTaskAction new action: [ contentsElement editor styleText ])
]

{ #category : #'private - announcement handling' }
GtLChatMessageElement >> onThreadMessageViewModelChanged: anAnnouncement [
	self enqueueTask: (BlTaskAction new action: [ self updateElement ])
]

{ #category : #'private - updating' }
GtLChatMessageElement >> showProgressElement [
	contentsElement visibility: BlVisibility gone.
	progressElement visibility: BlVisibility visible.
]

{ #category : #'private - hooks' }
GtLChatMessageElement >> subscribeToMessageViewModel [
	self messageViewModel weak
		when: GtLlmThreadMessageRestyleRequested
			send: #onRestyleRequested:
			to: self;
		when: GtLlmThreadMessageViewModelChanged
			send: #onThreadMessageViewModelChanged:
			to: self;
		when: GtLlmMessageContentsUpdated
			send: #onMessageContentsChanged:
			to: self
]

{ #category : #'private - hooks' }
GtLChatMessageElement >> unsubscribeFromMessageViewModel [
	self messageViewModel unsubscribe: self
]

{ #category : #'private - updating' }
GtLChatMessageElement >> updateContentsElement [
	contentsElement
		text: self threadMessageViewModel contentText;
		styler: self threadMessageViewModel styler
]

{ #category : #'private - updating' }
GtLChatMessageElement >> updateElement [
	self updateContentsElement.
	self updateProgressElement.
	self updateFailureIndicator.
]

{ #category : #'private - updating' }
GtLChatMessageElement >> updateFailureIndicator [
	self threadMessageViewModel isFailure
		ifTrue: [ self border: BrGlamorousColors errorBackgroundColor ]
		ifFalse: [ self border: BlBorder empty ]
]

{ #category : #'private - updating' }
GtLChatMessageElement >> updateProgressElement [
	self threadMessage hasResponse
		ifTrue: [ self hideProgressElement ]
		ifFalse: [ self showProgressElement ]
]
