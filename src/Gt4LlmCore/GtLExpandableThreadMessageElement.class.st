Class {
	#name : #GtLExpandableThreadMessageElement,
	#superclass : #BrExpander,
	#traits : 'TGtLWithMessageViewModel',
	#classTraits : 'TGtLWithMessageViewModel classTrait',
	#instVars : [
		'oneLineThreadMessageElement',
		'threadMessageElement'
	],
	#category : #'Gt4LlmCore-UI - Elements'
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
GtLExpandableThreadMessageElement >> beforeMessageViewModelReset [
	self margin: self margin - messageViewModel uiInsets
]

{ #category : #accessing }
GtLExpandableThreadMessageElement >> beforeThreadMessageViewModelReset [
	self margin: self margin - messageViewModel uiInsets
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
	oneLineThreadMessageElement := GtLMessageHeaderElement new.
]

{ #category : #'initialization ' }
GtLExpandableThreadMessageElement >> initializeThreadMessageElement [
	threadMessageElement := GtLMessageContentElement new
]

{ #category : #'initialization ' }
GtLExpandableThreadMessageElement >> onCollapsed [
	messageViewModel ifNotNil: [ :aViewModel | aViewModel isExpanded: false ]
]

{ #category : #'private - event handling' }
GtLExpandableThreadMessageElement >> onExpanded [
	messageViewModel ifNotNil: [ :aViewModel | aViewModel isExpanded: true ]
]

{ #category : #'private - hooks' }
GtLExpandableThreadMessageElement >> onMessageViewModelChanged [
	oneLineThreadMessageElement messageViewModel: messageViewModel.
	threadMessageElement messageViewModel: messageViewModel.
	self expanded: messageViewModel isExpanded.
	self margin: self margin + messageViewModel uiInsets
]
