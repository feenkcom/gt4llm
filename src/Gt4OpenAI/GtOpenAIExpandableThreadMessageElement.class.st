Class {
	#name : #GtOpenAIExpandableThreadMessageElement,
	#superclass : #BrExpander,
	#traits : 'TGtOpenAIWithThreadMessageViewModel',
	#classTraits : 'TGtOpenAIWithThreadMessageViewModel classTrait',
	#instVars : [
		'threadMessageElement',
		'moreContentElement'
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

	self initializeThreadMessageElement.
	self initializeMoreContentElement.
	
	self addChild: moreContentElement as: #more.

	self
		addAptitude: GtCoderExpanderAptitude new;
		header: [ threadMessageElement ];
		content: [ threadMessageElement ].

	self states withExpansion.
	self whenExpandedDo: [ self onExpanded ].
	self whenCollapsedDo: [ self onCollapsed ].
	self expand.

	self hMatchParent.
	self vFitContent
]

{ #category : #'initialization ' }
GtOpenAIExpandableThreadMessageElement >> initializeMoreContentElement [
	moreContentElement := BrButton new
			fitContent;
			beTinySize;
			zIndex: 1;
			background: Color white;
			margin: (BlInsets top: 0 right: 0 bottom: 1 left: 9);
			aptitude: (BrGlamorousButtonWithLabelAptitude new
					foreground: BrGlamorousColors disabledButtonTextColor);
			label: 'more';
			action: [ self expand ];
			constraintsDo: [ :c | 
				c ignoreByLayout.
				c ignored horizontal alignLeft.
				c ignored vertical alignBottom ]
]

{ #category : #'initialization ' }
GtOpenAIExpandableThreadMessageElement >> initializeThreadMessageElement [
	threadMessageElement := GtOpenAIThreadMessageElement new
]

{ #category : #'initialization ' }
GtOpenAIExpandableThreadMessageElement >> onCollapsed [
	moreContentElement visibility: BlVisibility visible.
	threadMessageElement
		ifNotNil: [  "aViewModel expanded: false.":aViewModel | 
			threadMessageElement
				contentsElementDo: [ :anEditor | anEditor constraintsDo: [ :c | c maxHeight: 120.0 ] ] ]
]

{ #category : #'private - event handling' }
GtOpenAIExpandableThreadMessageElement >> onExpanded [
	moreContentElement visibility: BlVisibility gone.
	threadMessageElement
		ifNotNil: [ :aViewModel | 
			"aViewModel expanded: true."
			threadMessageElement contentsElementDo: [ :anEditor | 
				anEditor constraintsDo: [ :c | c maxHeight: Float infinity ] ] ]
]

{ #category : #'private - hooks' }
GtOpenAIExpandableThreadMessageElement >> onThreadMessageViewModelChanged [
	threadMessageElement threadMessageViewModel: threadMessageViewModel
]
