Class {
	#name : #GtLMessageHeaderElement,
	#superclass : #GtBasicMessageElement,
	#instVars : [
		'senderElement',
		'contentElement',
		'contentLabelElement',
		'senderTooltipAptitude',
		'executionStateLabelElement'
	],
	#category : 'Gt4LlmCore-UI - Elements'
}

{ #category : #initialization }
GtLMessageHeaderElement >> defaultLayout [
	^ BlLinearLayout horizontal
]

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
	contentElement := BrHorizontalPane new
			hFitContentLimited;
			vFitContent;
			padding: (BlInsets left: 0 right: 15);
			addChild: (contentLabelElement := BrLabel new
						hFitContentLimited;
						vFitContent;
						aptitude: BrGlamorousLabelAptitude new;
						beSmallSize);
			addChild: (executionStateLabelElement := BrLabel new
						hFitContent;
						vFitContent;
						aptitude: (BrGlamorousLabelAptitude new foreground: self theme button disabledTextColor);
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
GtLMessageHeaderElement >> onMessageViewModelExecutionChangedChanged: anAnnouncement [
	self messageViewModel = anAnnouncement messageViewModel ifFalse: [ ^ self ].

	BlTaskAction enqueueElement: self action: [ self updateExecutionStateElement ]
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
			to: self;
		when: GtLMessageViewModelExecutionStateChanged
			send: #onMessageViewModelExecutionChangedChanged:
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
	self updateContentElement.
	self updateExecutionStateElement.
]

{ #category : #'private - updating' }
GtLMessageHeaderElement >> updateExecutionStateElement [
	executionStateLabelElement text: self messageViewModel messageExecutionStateLabel
]

{ #category : #'private - updating' }
GtLMessageHeaderElement >> updateSenderElement [
	senderElement text: self messageViewModel senderText.
	senderTooltipAptitude
		text: (String
				streamContents: [ :s | self messageViewModel createdAt asLocal printSeparateDateAndTimeOn: s ])
]
