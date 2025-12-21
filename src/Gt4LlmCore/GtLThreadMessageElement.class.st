Class {
	#name : #GtLThreadMessageElement,
	#superclass : #BlElement,
	#traits : 'TGtLlmWithThreadMessageViewModel + TBrLayoutResizable',
	#classTraits : 'TGtLlmWithThreadMessageViewModel classTrait + TBrLayoutResizable classTrait',
	#instVars : [
		'contentsElement',
		'progressElement',
		'timeTooltip'
	],
	#category : #'Gt4LlmCore-UI'
}

{ #category : #factory }
GtLThreadMessageElement class >> newForChatList [
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
GtLThreadMessageElement >> contentsAptitudeDo: aBlock [
	aBlock value: contentsElement aptitude
]

{ #category : #accessing }
GtLThreadMessageElement >> contentsElementDo: aBlock [
	aBlock value: contentsElement
]

{ #category : #initialization }
GtLThreadMessageElement >> defaultLayout [
	^ BlLinearLayout vertical
]

{ #category : #'private - updating' }
GtLThreadMessageElement >> hideProgressElement [
	contentsElement visibility: BlVisibility visible.
	progressElement visibility: BlVisibility gone.
]

{ #category : #initialization }
GtLThreadMessageElement >> initialize [
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
GtLThreadMessageElement >> initializeContentsElement [
	contentsElement := BrEditor new
			padding: (BlInsets all: 2);
			hMatchParent;
			vFitContentLimited;
			aptitude: BrGlamorousRegularEditorAptitude;
			beReadOnlyWithSelection
]

{ #category : #initialization }
GtLThreadMessageElement >> initializeProgressElement [
	progressElement := BrLabel new
			fitContent;
			aptitude: (BrGlamorousLabelAptitude new
					foreground: BrGlamorousColors disabledButtonTextColor);
			beSmallSize;
			text: 'Typing...';
			visibility: BlVisibility gone
]

{ #category : #'private - announcement handling' }
GtLThreadMessageElement >> onMessageContentsChanged: anAnnouncement [
	self enqueueTask: (BlTaskAction new action: [ self updateContentsElement ])
]

{ #category : #'private - announcement handling' }
GtLThreadMessageElement >> onRestyleRequested: anAnnouncement [
	self
		enqueueTask: (BlTaskAction new action: [ contentsElement editor styleText ])
]

{ #category : #'private - hooks' }
GtLThreadMessageElement >> onThreadMessageViewModelChanged [
	self updateElement
]

{ #category : #'private - announcement handling' }
GtLThreadMessageElement >> onThreadMessageViewModelChanged: anAnnouncement [
	self enqueueTask: (BlTaskAction new action: [ self updateElement ])
]

{ #category : #'private - updating' }
GtLThreadMessageElement >> showProgressElement [
	contentsElement visibility: BlVisibility gone.
	progressElement visibility: BlVisibility visible.
]

{ #category : #'private - hooks' }
GtLThreadMessageElement >> subscribeToThreadMessageViewModel [
	self threadMessageViewModel weak
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

{ #category : #'private - updating' }
GtLThreadMessageElement >> updateContentsElement [
	contentsElement
		text: self threadMessageViewModel contentText;
		styler: self threadMessageViewModel styler
]

{ #category : #'private - updating' }
GtLThreadMessageElement >> updateElement [
	self updateContentsElement.
	self updateProgressElement.
	self updateFailureIndicator.
]

{ #category : #'private - updating' }
GtLThreadMessageElement >> updateFailureIndicator [
	self threadMessageViewModel isFailure
		ifTrue: [ self border: BrGlamorousColors errorBackgroundColor ]
		ifFalse: [ self border: BlBorder empty ]
]

{ #category : #'private - updating' }
GtLThreadMessageElement >> updateProgressElement [
	self threadMessage hasResponse
		ifTrue: [ self hideProgressElement ]
		ifFalse: [ self showProgressElement ]
]
