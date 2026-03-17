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
		'toolsContentsElement'
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
			expand
]

{ #category : #initialization }
GtLReplyMessageContentElement >> initializeHeaderElement [
	headerElement := GtLMessageHeaderElement new
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
						do: [ :aWidget | headerElement showToolbarElement ]
						after: [ :aWidget | headerElement hideToolbarElement ] ])
]

{ #category : #initialization }
GtLReplyMessageContentElement >> initializeToolsExpanderElement [
	toolsHeaderElement := BrLabel new
			aptitude: BrGlamorousLabelAptitude;
			text: 'Executed tools'.
	toolsContentsElement := GtLMessageUsedToolsElement new
			hMatchParent;
			vFitContentLimited.

	toolsExpanderElement := BrExpander new
			addAptitude: (BrGlamorousExpanderSubtleAptitude new sidebarExtraPadding: (BlInsets top: 5));
			header: [ toolsHeaderElement ];
			content: [ toolsContentsElement ];
			hMatchParent;
			vFitContentLimited;
			collapse;
			visibility: BlVisibility gone.

	self
		withAsyncSinkDo: [ :anElementSink | 
			anElementSink
				sink: AsyncCounterSink new;
				whenUpdate: [ :anElement :aCounterSink | 
					toolsExpanderElement visibility: BlVisibility visible.
					toolsHeaderElement
						text: ('{1} executed {2}'
								format: {aCounterSink count.
										'tool' asPluralBasedOn: aCounterSink count}) ] ]
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

{ #category : #'as yet unclassified' }
GtLReplyMessageContentElement >> subscribeToMessageViewModel [
	super subscribeToMessageViewModel.

	self messageViewModel announcer weak
		when: GtLMessageViewModelContentsChanged
		send: #onMessageViewModelContentsChanged:
		to: self
]

{ #category : #'private - event handling' }
GtLReplyMessageContentElement >> updateContentsElement [
	self messageViewModel finalMessageViewModel
		ifNotNil: [ :aViewModel | contentsExpanderElement visibility: BlVisibility visible ]
		ifNil: [ contentsExpanderElement visibility: BlVisibility gone ]
]

{ #category : #'private - updating' }
GtLReplyMessageContentElement >> updateElement [
	self updateToolsContentsElement.
	self updateContentsElement.
]

{ #category : #'private - updating' }
GtLReplyMessageContentElement >> updateToolsContentsElement [
	self asyncSink
		forwardStream: self messageViewModel executionMessageViewModelsStream
]
