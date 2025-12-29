Class {
	#name : #GtLExpandableThreadMessageElement,
	#superclass : #BrExpander,
	#traits : 'TGtLWithChatMessageViewModel',
	#classTraits : 'TGtLWithChatMessageViewModel classTrait',
	#instVars : [
		'oneLineThreadMessageElement',
		'threadMessageElement'
	],
	#category : #'Gt4LlmCore-UI'
}

{ #category : #factory }
GtLExpandableThreadMessageElement class >> newForChatList [
	^ self new
		margin: (BlInsets
				top: 5
				bottom: 10
				left: 5
				right: 5);
		collapse
]

{ #category : #accessing }
GtLExpandableThreadMessageElement >> beforeThreadMessageViewModelReset [
	self margin: self margin - threadMessageViewModel uiInsets
]

{ #category : #'initialization ' }
GtLExpandableThreadMessageElement >> initialize [
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
GtLExpandableThreadMessageElement >> initializeOneLineThreadMessageElement [
	oneLineThreadMessageElement := GtLThreadMessageHeaderElement new.
]

{ #category : #'initialization ' }
GtLExpandableThreadMessageElement >> initializeThreadMessageElement [
	threadMessageElement := GtLThreadMessageContentElement new
]

{ #category : #'initialization ' }
GtLExpandableThreadMessageElement >> onCollapsed [
	threadMessageViewModel ifNotNil: [ :aViewModel | aViewModel isExpanded: false ]
]

{ #category : #'private - event handling' }
GtLExpandableThreadMessageElement >> onExpanded [
	threadMessageViewModel ifNotNil: [ :aViewModel | aViewModel isExpanded: true ]
]

{ #category : #'private - hooks' }
GtLExpandableThreadMessageElement >> onThreadMessageViewModelChanged [
	oneLineThreadMessageElement threadMessageViewModel: threadMessageViewModel.
	threadMessageElement threadMessageViewModel: threadMessageViewModel.
	self expanded: threadMessageViewModel isExpanded.
	self margin: self margin + threadMessageViewModel uiInsets
]
