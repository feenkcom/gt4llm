"
I render a user chat message with a header and an expandable content area.

## Example
{{gtExample:GtLChatOpenAIElementExamples>>#userMessageElement|noCode|previewExpanded}}
"
Class {
	#name : #GtLUserMessageContentElement,
	#superclass : #GtLBasicMessageElement,
	#instVars : [
		'headerElement',
		'contentsExpanderElement',
		'contentsElement',
		'contentsHeaderElement'
	],
	#category : 'Gt4LlmCore-UI - Elements'
}

{ #category : #'instance creation' }
GtLUserMessageContentElement class >> newForChatList [
	^ self new
		margin: (BlInsets
				top: 5
				bottom: 10
				left: 5
				right: 5)
]

{ #category : #initialization }
GtLUserMessageContentElement >> defaultLayout [
	^ BlLinearLayout vertical
]

{ #category : #initialization }
GtLUserMessageContentElement >> initialize [
	super initialize.
	
	self initializeHeaderElement.
	self initializeContentsExpanderElement.
	self initializeStyling.

	self
		hMatchParent;
		vFitContentLimited.

	self addChild: headerElement as: #'message-header'.
	self addChild: contentsExpanderElement as: #'message--contents'
]

{ #category : #initialization }
GtLUserMessageContentElement >> initializeContentsExpanderElement [
	contentsElement := GtLMessageViewsElement new.
	contentsHeaderElement := GtMessageOneLineMultiLabelSummaryElement new
			id: #'chat--message-content'.

	contentsExpanderElement := BrExpander new
			addAptitude: (BrGlamorousExpanderSubtleAptitude new sidebarExtraPadding: (BlInsets top: 5));
			header: [ contentsHeaderElement ];
			content: [ contentsElement ];
			hMatchParent;
			vFitContentLimited;
			expand;
			whenExpandedDo: [ :anEvent | self onContentsExpanded: anEvent ];
			whenCollapsedDo: [ :anEvent | self onContentsCollapsed: anEvent ].

	contentsHeaderElement
		when: BlClickEvent
		do: [ :anEvent | 
			anEvent consumed: true.
			contentsExpanderElement expand ]
]

{ #category : #initialization }
GtLUserMessageContentElement >> initializeHeaderElement [
	headerElement := GtLMessageSenderAndDateHeaderElement new hideToolbarElement
]

{ #category : #initialization }
GtLUserMessageContentElement >> initializeStyling [
	self padding: (BlInsets all: 5).
	self background: self theme default contentBackground.
	self
		addAptitude: BlGlamorousExpanderShadowAptitude new;
		addAptitude: (BrLazyStyleCommonAptitude new
				when: BlElementState hovered | BlElementState focused
				style: [ :aStyle :aTheme | 
					aStyle
						do: [ :aWidget | headerElement showToolbarElement ]
						after: [ :aWidget | headerElement hideToolbarElement ] ])
]

{ #category : #'private - event handling' }
GtLUserMessageContentElement >> onContentsCollapsed: anEvent [
	self messageViewModel ifNil: [ ^ self ].

	self messageViewModel isExpanded: false source: self
]

{ #category : #'private - event handling' }
GtLUserMessageContentElement >> onContentsExpanded: anEvent [
	self messageViewModel ifNil: [ ^ self ].
	
	self messageViewModel isExpanded: true source: self
]

{ #category : #'private - hooks' }
GtLUserMessageContentElement >> onMessageViewModelChanged [
	super onMessageViewModelChanged.
	headerElement messageViewModel: self messageViewModel.
	contentsElement messageViewModel: self messageViewModel.
	contentsHeaderElement messageViewModel: self messageViewModel.
	self updateElement.
]

{ #category : #'private - event handling' }
GtLUserMessageContentElement >> onMessageViewModelExpansionChanged: anAnnouncement [
	self messageViewModel = anAnnouncement messageViewModel ifFalse: [ ^ self ].

	BlTaskAction
		enqueueElement: self
		action: [ self updateContentsExpanderElement ]
]

{ #category : #'as yet unclassified' }
GtLUserMessageContentElement >> subscribeToMessageViewModel [
	super subscribeToMessageViewModel.

	self messageViewModel announcer weak
		when: GtLMessageViewModelExpansionChanged
			send: #onMessageViewModelExpansionChanged:
			to: self
]

{ #category : #'private - updating' }
GtLUserMessageContentElement >> updateContentsExpanderElement [
	contentsExpanderElement expanded: self messageViewModel isExpanded
]

{ #category : #'private - updating' }
GtLUserMessageContentElement >> updateElement [
	self updateContentsExpanderElement
]
