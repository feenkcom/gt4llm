Class {
	#name : #GtLExpandableMessageElement,
	#superclass : #BrExpander,
	#traits : 'TGtLWithMessageViewModel',
	#classTraits : 'TGtLWithMessageViewModel classTrait',
	#instVars : [
		'contentElement',
		'headerElement'
	],
	#category : #'Gt4LlmCore-UI - Elements'
}

{ #category : #factory }
GtLExpandableMessageElement class >> newForChatList [
	^ self new
		margin: (BlInsets
				top: 5
				bottom: 10
				left: 5
				right: 5);
		collapse
]

{ #category : #accessing }
GtLExpandableMessageElement >> beforeMessageViewModelReset [
	self margin: self margin - messageViewModel uiInsets
]

{ #category : #accessing }
GtLExpandableMessageElement >> beforeThreadMessageViewModelReset [
	self margin: self margin - messageViewModel uiInsets
]

{ #category : #'initialization ' }
GtLExpandableMessageElement >> initialize [
	super initialize.

	self initializeOneLineMessageElement.
	self initializeContentMessageElement.

	self
		addAptitude: GtCoderExpanderAptitude new;
		header: [ headerElement ];
		content: [ contentElement ].

	self
		addAptitude: (BrLazyStyleCommonAptitude new
				when: BlElementState collapsed & (BlElementState hovered | BlElementState focused)
				style: [ :aStyle :aTheme | 
					aStyle
						do: [ :aWidget | headerElement showToolbarElement ]
						after: [ :aWidget | headerElement hideToolbarElement ] ]).

	self states withExpansion.
	self whenExpandedDo: [ self onExpanded ].
	self whenCollapsedDo: [ self onCollapsed ].
	self expand.

	self hMatchParent.
	self vFitContentLimited
]

{ #category : #'initialization ' }
GtLExpandableMessageElement >> initializeContentMessageElement [
	contentElement := GtLMessageContentElement new
]

{ #category : #'initialization ' }
GtLExpandableMessageElement >> initializeOneLineMessageElement [
	headerElement := GtLMessageHeaderElement new.
	headerElement hideToolbarElement.
]

{ #category : #'initialization ' }
GtLExpandableMessageElement >> onCollapsed [
	messageViewModel ifNotNil: [ :aViewModel | aViewModel isExpanded: false ]
]

{ #category : #'private - event handling' }
GtLExpandableMessageElement >> onExpanded [
	messageViewModel ifNotNil: [ :aViewModel | aViewModel isExpanded: true ]
]

{ #category : #'private - hooks' }
GtLExpandableMessageElement >> onMessageViewModelChanged [
	headerElement messageViewModel: messageViewModel.
	contentElement messageViewModel: messageViewModel.
	self expanded: messageViewModel isExpanded.
	self margin: self margin + messageViewModel uiInsets
]

{ #category : #'private - event handling' }
GtLExpandableMessageElement >> onMessageViewModelExpansionChanged: anAnnouncement [
	anAnnouncement messageViewModel = self messageViewModel ifFalse: [ ^ self ].

	BlTaskAction
		enqueueElement: self
		action: [ self expanded: self messageViewModel isExpanded ]
]

{ #category : #'private - hooks' }
GtLExpandableMessageElement >> subscribeToMessageViewModel [
	self messageViewModel announcer weak
		when: GtLMessageViewModelExpansionChanged
		send: #onMessageViewModelExpansionChanged:
		to: self
]
