Class {
	#name : #GtLlmThreadMessageElement,
	#superclass : #BlElement,
	#traits : 'TGtLlmWithThreadMessageViewModel + TBrLayoutResizable',
	#classTraits : 'TGtLlmWithThreadMessageViewModel classTrait + TBrLayoutResizable classTrait',
	#instVars : [
		'contentsElement',
		'progressElement',
		'timeTooltip'
	],
	#category : #'Gt4Llm-GToolkit'
}

{ #category : #factory }
GtLlmThreadMessageElement class >> newForChatList [
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
GtLlmThreadMessageElement >> contentsAptitudeDo: aBlock [
	aBlock value: contentsElement aptitude
]

{ #category : #accessing }
GtLlmThreadMessageElement >> contentsElementDo: aBlock [
	aBlock value: contentsElement
]

{ #category : #initialization }
GtLlmThreadMessageElement >> defaultLayout [
	^ BlLinearLayout vertical
]

{ #category : #'private - updating' }
GtLlmThreadMessageElement >> hideProgressElement [
	contentsElement visibility: BlVisibility visible.
	progressElement visibility: BlVisibility gone.
]

{ #category : #initialization }
GtLlmThreadMessageElement >> initialize [
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
GtLlmThreadMessageElement >> initializeContentsElement [
	contentsElement := BrEditor new
			padding: (BlInsets all: 2);
			hMatchParent;
			vFitContentLimited;
			aptitude: BrGlamorousRegularEditorAptitude;
			beReadOnlyWithSelection
]

{ #category : #initialization }
GtLlmThreadMessageElement >> initializeProgressElement [
	progressElement := BrLabel new
			fitContent;
			aptitude: (BrGlamorousLabelAptitude new
					foreground: BrGlamorousColors disabledButtonTextColor);
			beSmallSize;
			text: 'Typing...';
			visibility: BlVisibility gone
]

{ #category : #'private - announcement handling' }
GtLlmThreadMessageElement >> onMessageContentsChanged: anAnnouncement [
	self enqueueTask: (BlTaskAction new action: [ self updateContentsElement ])
]

{ #category : #'private - announcement handling' }
GtLlmThreadMessageElement >> onRestyleRequested: anAnnouncement [
	self
		enqueueTask: (BlTaskAction new action: [ contentsElement editor styleText ])
]

{ #category : #'private - hooks' }
GtLlmThreadMessageElement >> onThreadMessageViewModelChanged [
	self updateElement
]

{ #category : #'private - announcement handling' }
GtLlmThreadMessageElement >> onThreadMessageViewModelChanged: anAnnouncement [
	self enqueueTask: (BlTaskAction new action: [ self updateElement ])
]

{ #category : #'private - updating' }
GtLlmThreadMessageElement >> showProgressElement [
	contentsElement visibility: BlVisibility gone.
	progressElement visibility: BlVisibility visible.
]

{ #category : #'private - hooks' }
GtLlmThreadMessageElement >> subscribeToThreadMessageViewModel [
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
GtLlmThreadMessageElement >> updateContentsElement [
	contentsElement
		text: self threadMessageViewModel contentText;
		styler: self threadMessageViewModel styler
]

{ #category : #'private - updating' }
GtLlmThreadMessageElement >> updateElement [
	self updateContentsElement.
	self updateProgressElement.
	self updateFailureIndicator.
]

{ #category : #'private - updating' }
GtLlmThreadMessageElement >> updateFailureIndicator [
	self threadMessageViewModel isFailure
		ifTrue: [ self border: BrGlamorousColors errorBackgroundColor ]
		ifFalse: [ self border: BlBorder empty ]
]

{ #category : #'private - updating' }
GtLlmThreadMessageElement >> updateProgressElement [
	self threadMessage hasResponse
		ifTrue: [ self hideProgressElement ]
		ifFalse: [ self showProgressElement ]
]
