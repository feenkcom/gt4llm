Class {
	#name : #GtLReplyMessageContentElement,
	#superclass : #GtLBasicMessageElement,
	#instVars : [
		'headerElement',
		'toolsExpanderElement',
		'toolsHeaderElement',
		'toolsContentElement',
		'contentsExpanderElement',
		'contentsElement',
		'contentsHeaderElement'
	],
	#category : #'Gt4LlmCore-UI - Elements'
}

{ #category : #'instance creation' }
GtLReplyMessageContentElement class >> newForChatList [
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

{ #category : #initialization }
GtLReplyMessageContentElement >> defaultLayout [
	^ BlLinearLayout vertical
]

{ #category : #initialization }
GtLReplyMessageContentElement >> initialize [
	super initialize.

	self initializeHeaderElement.
	self initializeToolsExpanderElement.
	self initializeMessageContentElement.

	self
		hMatchParent;
		vFitContentLimited.

	self addChild: headerElement as: #'message-header'.
	self addChild: toolsExpanderElement as: #'executed-tools'.
	self addChild: contentsExpanderElement as: #'message--contents'
]

{ #category : #initialization }
GtLReplyMessageContentElement >> initializeHeaderElement [
	headerElement := GtLMessageHeaderElement new
]

{ #category : #initialization }
GtLReplyMessageContentElement >> initializeMessageContentElement [
	contentsElement := GtLMessageViewsElement new.
	contentsHeaderElement := GtLMessageHeaderElement new.
	
	contentsExpanderElement := BrExpander new
			addAptitude: (BrGlamorousExpanderSubtleAptitude new sidebarExtraPadding: (BlInsets top: 5));
			header: [ contentsHeaderElement ];
			content: [ contentsElement ];
			hMatchParent;
			vFitContentLimited;
			collapse
]

{ #category : #initialization }
GtLReplyMessageContentElement >> initializeToolsExpanderElement [
	toolsHeaderElement := BrLabel new
			aptitude: BrGlamorousLabelAptitude;
			text: 'Executed tools'.
	toolsContentElement := GtLMessageUsedToolsElement new
			hMatchParent;
			vFitContentLimited.

	toolsExpanderElement := BrExpander new
			addAptitude: (BrGlamorousExpanderSubtleAptitude new sidebarExtraPadding: (BlInsets top: 5));
			header: [ toolsHeaderElement ];
			content: [ toolsContentElement ];
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
	toolsContentElement messageViewModel: self messageViewModel.
	contentsElement messageViewModel: self messageViewModel.
	contentsHeaderElement messageViewModel: self messageViewModel.
	self updateElement.
]

{ #category : #'private - updating' }
GtLReplyMessageContentElement >> updateElement [
	self asyncSink
		forwardStream: self messageViewModel executionMessageViewModelsStream
]
