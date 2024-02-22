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
		addAptitude: GtCoderExpanderAptitude new;
		header: [ threadMessageElement removeFromParent ];
		content: [ threadMessageElement removeFromParent ].

	self states withExpansion.
	self whenExpandedDo: [ self onExpanded ].
	self whenCollapsedDo: [ self onCollapsed ].
	self expand.

	self hMatchParent.
	self vFitContent
]

{ #category : #'initialization ' }
GtOpenAIExpandableThreadMessageElement >> initializeThreadMessageElement [
	threadMessageElement := GtOpenAIThreadMessageElement new
]

{ #category : #'initialization ' }
GtOpenAIExpandableThreadMessageElement >> onCollapsed [
	threadMessageElement
		ifNotNil: [  :aViewModel | 
			"aViewModel expanded: false."
			threadMessageElement contentsElementDo: [ :anEditor | 
				anEditor constraintsDo: [ :c | c maxHeight: 120.0 ] ] ]
]

{ #category : #'private - event handling' }
GtOpenAIExpandableThreadMessageElement >> onExpanded [
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
