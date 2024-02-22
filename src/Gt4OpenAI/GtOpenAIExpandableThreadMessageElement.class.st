Class {
	#name : #GtOpenAIExpandableThreadMessageElement,
	#superclass : #BrExpander,
	#traits : 'TGtOpenAIWithThreadMessageViewModel',
	#classTraits : 'TGtOpenAIWithThreadMessageViewModel classTrait',
	#instVars : [
		'threadMessageElement',
		'moreContentElement',
		'oneLineThreadMessageElement'
	],
	#category : #'Gt4OpenAI-Widgets'
}

{ #category : #factory }
GtOpenAIExpandableThreadMessageElement class >> newForChatList [
	^ self new
		"geometry: (BlRoundedRectangleGeometry cornerRadius: 2);"
		"background: Color white;"
		"addAptitude: BrGlamorousFocusableShadowAptitude new;"
		margin: (BlInsets
				top: 3
				bottom: 12
				left: 5
				right: 10)
]

{ #category : #'initialization ' }
GtOpenAIExpandableThreadMessageElement >> initialize [
	super initialize.

	self initializeOneLineThreadMessageElement.
	self initializeThreadMessageElement.
	
	self
		addAptitude: GtCoderExpanderAptitude new;
		header: [ oneLineThreadMessageElement ];
		content: [ threadMessageElement ].

	self states withExpansion.
	self whenExpandedDo: [ self onExpanded ].
	self whenCollapsedDo: [ self onCollapsed ].
	self expand.

	self hMatchParent.
	self vFitContentLimited
]

{ #category : #'initialization ' }
GtOpenAIExpandableThreadMessageElement >> initializeOneLineThreadMessageElement [
	oneLineThreadMessageElement := GtOpenAIThreadMessageElement new
			contentsAptitudeDo: [ :anAptitude | 
				anAptitude foreground: BrGlamorousColors disabledButtonTextColor ]
]

{ #category : #'initialization ' }
GtOpenAIExpandableThreadMessageElement >> initializeThreadMessageElement [
	threadMessageElement := GtOpenAIThreadMessageElement new
]

{ #category : #'initialization ' }
GtOpenAIExpandableThreadMessageElement >> onCollapsed [
	threadMessageViewModel ifNotNil: [ :aViewModel | aViewModel isExpanded: false ]
]

{ #category : #'private - event handling' }
GtOpenAIExpandableThreadMessageElement >> onExpanded [
	threadMessageViewModel ifNotNil: [ :aViewModel | aViewModel isExpanded: true ]
]

{ #category : #'private - hooks' }
GtOpenAIExpandableThreadMessageElement >> onThreadMessageViewModelChanged [
	oneLineThreadMessageElement threadMessageViewModel: threadMessageViewModel asOneLineViewModel.
	threadMessageElement threadMessageViewModel: threadMessageViewModel.
	self expanded: threadMessageViewModel isExpanded 
]
