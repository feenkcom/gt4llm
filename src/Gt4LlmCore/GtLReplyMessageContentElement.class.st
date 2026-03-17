Class {
	#name : #GtLReplyMessageContentElement,
	#superclass : #GtLBasicMessageElement,
	#instVars : [
		'headerElement',
		'toolsExpanderElement',
		'toolsHeaderElement',
		'contentsExpanderElement',
		'contentsElement',
		'contentsHeaderElement',
		'toolsContentsElement',
		'toolsResizerAptitude',
		'mayBeToolsResizerVisible'
	],
	#category : #'Gt4LlmCore-UI - Elements'
}

{ #category : #'instance creation' }
GtLReplyMessageContentElement class >> newForChatList [
	^ self new
		margin: (BlInsets
				top: 5
				bottom: 10
				left: 5
				right: 5)
]

{ #category : #initialization }
GtLReplyMessageContentElement >> defaultLayout [
	^ BlLinearLayout vertical
]

{ #category : #initialization }
GtLReplyMessageContentElement >> initialize [
	super initialize.
	
	mayBeToolsResizerVisible := false.

	self initializeHeaderElement.
	self initializeToolsExpanderElement.
	self initializeContentsExpanderElement.
	self initializeStyling.

	self
		hMatchParent;
		vFitContentLimited.

	self addChild: headerElement as: #'message-header'.
	self addChild: toolsExpanderElement as: #'executed-tools'.
	self addChild: contentsExpanderElement as: #'message--contents'
]

{ #category : #initialization }
GtLReplyMessageContentElement >> initializeContentsExpanderElement [
	contentsElement := GtLMessageViewsElement new.
	contentsHeaderElement := GtMessageOneLineMultiLabelSummaryElement new.
	
	contentsExpanderElement := BrExpander new
			addAptitude: (BrGlamorousExpanderSubtleAptitude new sidebarExtraPadding: (BlInsets top: 5));
			header: [ contentsHeaderElement ];
			content: [ contentsElement ];
			hMatchParent;
			vFitContentLimited;
			expand;
			whenExpandedDo: [ :anEvent | self onContentsExpanded: anEvent ];
			whenCollapsedDo: [ :anEvent | self onContentsCollapsed: anEvent ]
]

{ #category : #initialization }
GtLReplyMessageContentElement >> initializeHeaderElement [
	headerElement := GtLReplyMessageHeaderElement new
]

{ #category : #initialization }
GtLReplyMessageContentElement >> initializeStyling [
	self padding: (BlInsets all: 5).
	self background: self theme default contentBackground.
	self
		addAptitude: BlGlamorousExpanderShadowAptitude new;
		addAptitude: (BrLazyStyleCommonAptitude new
				when: BlElementState hovered | BlElementState focused
				style: [ :aStyle :aTheme | 
					aStyle
						do: [ :aWidget | 
							headerElement showToolbarElement.
							mayBeToolsResizerVisible
								ifTrue: [ toolsResizerAptitude showResizer ]
								ifFalse: [ toolsResizerAptitude hideResizer ] ]
						after: [ :aWidget | 
							headerElement hideToolbarElement.
							toolsResizerAptitude hideResizer ] ])
]

{ #category : #initialization }
GtLReplyMessageContentElement >> initializeToolsExpanderElement [
	toolsHeaderElement := BrLabel new
			aptitude: BrGlamorousLabelAptitude;
			text: 'Tools'.
	toolsContentsElement := GtLMessageUsedToolsElement new
			hMatchParent;
			padding: (BlInsets bottom: 10);
			vFitContentLimited;
			addAptitude: (toolsResizerAptitude := BrGlamorousWithVerticalResizerAptitude new
						beBottom;
						resizerDo: [ :aResizer | 
							aResizer
								when: BlDoubleClickEvent
								do: [ :anEvent | self onResizerDoubleClickEvent: anEvent ] ];
						whenResizedDo: [ :anEvent | self onToolsExpanderResized: anEvent ]).

	toolsExpanderElement := BrExpander new
			addAptitude: (BrGlamorousExpanderSubtleAptitude new sidebarExtraPadding: (BlInsets top: 5));
			header: [ toolsHeaderElement ];
			content: [ toolsContentsElement ];
			hMatchParent;
			vFitContentLimited;
			collapse;
			visibility: BlVisibility gone;
			whenExpandedDo: [ :anEvent | self onToolsExpanded: anEvent ];
			whenCollapsedDo: [ :anEvent | self onToolsCollapsed: anEvent ].

	self
		withAsyncSinkDo: [ :anElementSink | 
			anElementSink
				sink: AsyncCounterSink new;
				whenUpdate: [ :anElement :aCounterSink | self onToolsCounterSinkUpdate: aCounterSink ] ]
]

{ #category : #'private - event handling' }
GtLReplyMessageContentElement >> onContentsCollapsed: anEvent [
	self messageViewModel ifNil: [ ^ self ].

	self messageViewModel isContentsExpanded: false source: self
]

{ #category : #'private - event handling' }
GtLReplyMessageContentElement >> onContentsExpanded: anEvent [
	self messageViewModel ifNil: [ ^ self ].
	
	self messageViewModel isContentsExpanded: true source: self
]

{ #category : #'private - hooks' }
GtLReplyMessageContentElement >> onMessageViewModelChanged [
	super onMessageViewModelChanged.
	headerElement messageViewModel: self messageViewModel.
	toolsContentsElement messageViewModel: self messageViewModel.
	contentsElement messageViewModel: self messageViewModel.
	contentsHeaderElement messageViewModel: self messageViewModel.
	self updateElement.
]

{ #category : #'private - event handling' }
GtLReplyMessageContentElement >> onMessageViewModelContentsChanged: anAnnouncement [
	self messageViewModel = anAnnouncement messageViewModel ifFalse: [ ^ self ].
	
	BlTaskAction enqueueElement: self action: [ self updateContentsElement]
]

{ #category : #'private - event handling' }
GtLReplyMessageContentElement >> onMessageViewModelExpansionChanged: anAnnouncement [
	self messageViewModel = anAnnouncement messageViewModel ifFalse: [ ^ self ].

	BlTaskAction
		enqueueElement: self
		action: [ self updateContentsExpanderElement ]
]

{ #category : #'private - event handling' }
GtLReplyMessageContentElement >> onResizerDoubleClickEvent: anEvent [ 
	anEvent consumed: true.
	
	toolsContentsElement vFitContentLimited.
	self messageViewModel toolsContentsHeight: nil.
]

{ #category : #'private - event handling' }
GtLReplyMessageContentElement >> onToolsCollapsed: anEvent [
	self messageViewModel ifNil: [ ^ self ].

	self messageViewModel isToolsExpanded: false source: self
]

{ #category : #'private - event handling' }
GtLReplyMessageContentElement >> onToolsCounterSinkUpdate: aCounterSink [
	toolsExpanderElement visibility: BlVisibility visible.
	toolsHeaderElement
		text: ('{1} {2}'
				format: {aCounterSink count.
						'tool' asPluralBasedOn: aCounterSink count}).

	self updateToolsResizerVisiblity: aCounterSink count > 10
]

{ #category : #'private - event handling' }
GtLReplyMessageContentElement >> onToolsExpanded: anEvent [
	self messageViewModel ifNil: [ ^ self ].
	
	self messageViewModel isToolsExpanded: true source: self
]

{ #category : #'private - event handling' }
GtLReplyMessageContentElement >> onToolsExpanderResized: anEvent [
	anEvent consumed: true.
	self messageViewModel ifNil: [ ^ self ].

	self messageViewModel toolsContentsHeight: toolsContentsElement height
]

{ #category : #'as yet unclassified' }
GtLReplyMessageContentElement >> subscribeToMessageViewModel [
	super subscribeToMessageViewModel.

	self messageViewModel announcer weak
		when: GtLMessageViewModelContentsChanged
			send: #onMessageViewModelContentsChanged:
			to: self;
		when: GtLMessageViewModelExpansionChanged
			send: #onMessageViewModelExpansionChanged:
			to: self
]

{ #category : #'private - event handling' }
GtLReplyMessageContentElement >> updateContentsElement [
	self messageViewModel finalMessageViewModel
		ifNotNil: [ :aViewModel | contentsExpanderElement visibility: BlVisibility visible ]
		ifNil: [ contentsExpanderElement visibility: BlVisibility gone ]
]

{ #category : #'private - updating' }
GtLReplyMessageContentElement >> updateContentsExpanderElement [
	contentsExpanderElement expanded: self messageViewModel isContentsExpanded
]

{ #category : #'private - updating' }
GtLReplyMessageContentElement >> updateElement [
	self updateToolsExpanderElement.
	self updateToolsContentsElement.
	self updateContentsExpanderElement.
	self updateContentsElement.
]

{ #category : #'private - updating' }
GtLReplyMessageContentElement >> updateToolsContentsElement [
	self asyncSink
		forwardStream: self messageViewModel executionMessageViewModelsStream.

	self messageViewModel toolsContentsHeight
		ifNotNil: [ :aNumber | toolsContentsElement vExact: aNumber ]
		ifNil: [ toolsContentsElement vFitContentLimited ]
]

{ #category : #'private - updating' }
GtLReplyMessageContentElement >> updateToolsExpanderElement [
	toolsExpanderElement expanded: self messageViewModel isToolsExpanded
]

{ #category : #'private - updating' }
GtLReplyMessageContentElement >> updateToolsResizerVisiblity: mayBeVisible [
	mayBeToolsResizerVisible = mayBeVisible ifTrue: [ ^ self ].
	
	mayBeToolsResizerVisible := mayBeVisible.
	
	self requestStyle
]
