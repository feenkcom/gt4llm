Class {
	#name : #GtOpenAIExpandableThreadMessageElement,
	#superclass : #BrExpander,
	#traits : 'TGtOpenAIWithThreadMessageViewModel',
	#classTraits : 'TGtOpenAIWithThreadMessageViewModel classTrait',
	#instVars : [
		'threadMessageElement'
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

	self
		addAptitude: BrGlamorousExpanderAptitude new;
		header: [ threadMessageElement
				removeFromParent;
				constraintsDo: [ :c "c maxHeight: 100" |  ] ];
		content: [ threadMessageElement
				removeFromParent;
				constraintsDo: [ :c "c maxHeight: Float infinity" |  ] ].

	self whenExpandedDo: [ self constraintsDo: [ :c | c maxHeight: Float infinity ] ].
	self
		whenCollapsedDo: [ self constraintsDo: [ :c | c maxHeight: 120.0 ] ].

	self hMatchParent.
	self vFitContent.
	self collapse
]

{ #category : #'initialization ' }
GtOpenAIExpandableThreadMessageElement >> initializeThreadMessageElement [
	threadMessageElement := GtOpenAIThreadMessageElement new
]

{ #category : #'private - hooks' }
GtOpenAIExpandableThreadMessageElement >> onThreadMessageViewModelChanged [
	threadMessageElement threadMessageViewModel: threadMessageViewModel
]
