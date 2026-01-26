Class {
	#name : #GtLMessageHeaderElement,
	#superclass : #BrHorizontalPane,
	#traits : 'TGtLWithMessageViewModel',
	#classTraits : 'TGtLWithMessageViewModel classTrait',
	#instVars : [
		'senderElement',
		'contentElement',
		'contentLabelElement',
		'senderTooltipAptitude'
	],
	#category : 'Gt4LlmCore-UI - Elements'
}

{ #category : #initialization }
GtLMessageHeaderElement >> initialize [
	super initialize.
	
	self initializeSenderElement.
	self initializeContentElement.
	
	self addChild: senderElement as: #sender.
	self addChild: contentElement as: #content.
	
	self vFitContent.
	self hMatchParent
]

{ #category : #initialization }
GtLMessageHeaderElement >> initializeContentElement [
	contentElement := BrFrame new
			matchParent;
			padding: (BlInsets left: 0 right: 15);
			addChild: (contentLabelElement := BrLabel new
						hFitContentLimited;
						vFitContent;
						aptitude: BrGlamorousLabelAptitude new;
						beSmallSize)
]

{ #category : #initialization }
GtLMessageHeaderElement >> initializeSenderElement [
	senderElement := BrLabel new
			hFitContentLimited;
			vFitContent;
			aptitude: (BrGlamorousLabelAptitude new
					foreground: BrGlamorousColors disabledButtonTextColor);
			beSmallSize;
			addAptitude: (senderTooltipAptitude := BrGlamorousWithExplicitTooltipAptitude new)
]

{ #category : #'private - hooks' }
GtLMessageHeaderElement >> onMessageViewModelChanged [
	self updateElement
]

{ #category : #'private - event handling' }
GtLMessageHeaderElement >> onMessageViewModelContentsChanged: anAnnouncement [
	BlTaskAction enqueueElement: self action: [ self updateElement ]
]

{ #category : #'private - event handling' }
GtLMessageHeaderElement >> onThreadMessageViewModelChanged: anAnnouncement [
	BlTaskAction enqueueElement: self action: [ self updateElement ]
]

{ #category : #'private - hooks' }
GtLMessageHeaderElement >> subscribeToMessageViewModel [
	self messageViewModel weak
		when: GtLlmThreadMessageViewModelChanged
			send: #onThreadMessageViewModelChanged:
			to: self;
		when: GtLMessageViewModelContentsChanged
			send: #onMessageViewModelContentsChanged:
			to: self
]

{ #category : #'private - hooks' }
GtLMessageHeaderElement >> unsubscribeFromMessageViewModel [
	self messageViewModel unsubscribe: self
]

{ #category : #'private - updating' }
GtLMessageHeaderElement >> updateContentElement [
	contentLabelElement text: self messageViewModel contentText
]

{ #category : #'private - updating' }
GtLMessageHeaderElement >> updateElement [
	self updateSenderElement.
	self updateContentElement
]

{ #category : #'private - updating' }
GtLMessageHeaderElement >> updateSenderElement [
	senderElement text: self messageViewModel senderText.
	senderTooltipAptitude
		text: (String
				streamContents: [ :s | self messageViewModel createdAt asLocal printSeparateDateAndTimeOn: s ])
]
