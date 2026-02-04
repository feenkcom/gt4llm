Class {
	#name : #GtMessageOneLineSummaryElement,
	#superclass : #GtLBasicMessageElement,
	#traits : 'TBrSizeAdjustable',
	#classTraits : 'TBrSizeAdjustable classTrait',
	#instVars : [
		'labelElement'
	],
	#category : #'Gt4LlmCore-UI - Elements'
}

{ #category : #initialization }
GtMessageOneLineSummaryElement >> defaultLayout [
	^ BlLinearLayout horizontal
]

{ #category : #initialization }
GtMessageOneLineSummaryElement >> initialize [
	super initialize.

	self initializeLabelElement.

	self addChild: labelElement as: #'chat--message-content-label'.
	self addAptitude: (BrLayoutResizerAptitude new common: labelElement).

	self
		hFitContentLimited;
		vFitContent
]

{ #category : #initialization }
GtMessageOneLineSummaryElement >> initializeLabelElement [
	labelElement := BrLabel new
			hFitContentLimited;
			vFitContent;
			aptitude: BrGlamorousLabelAptitude new;
			beSmallSize
]

{ #category : #'private - hooks' }
GtMessageOneLineSummaryElement >> onMessageViewModelChanged [
	super onMessageViewModelChanged.
	self updateElement
]

{ #category : #'private - event handling' }
GtMessageOneLineSummaryElement >> onMessageViewModelContentsChanged: anAnnouncement [
	self messageViewModel = anAnnouncement messageViewModel ifFalse: [ ^ self ].

	BlTaskAction enqueueElement: self action: [ self updateElement ]
]

{ #category : #'private - event handling' }
GtMessageOneLineSummaryElement >> onThreadMessageViewModelChanged: anAnnouncement [
	BlTaskAction enqueueElement: self action: [ self updateElement ]
]

{ #category : #'private - hooks' }
GtMessageOneLineSummaryElement >> subscribeToMessageViewModel [
	super subscribeToMessageViewModel.
	self messageViewModel weak
		when: GtLlmThreadMessageViewModelChanged
			send: #onThreadMessageViewModelChanged:
			to: self;
		when: GtLMessageViewModelContentsChanged
			send: #onMessageViewModelContentsChanged:
			to: self
]

{ #category : #accessing }
GtMessageOneLineSummaryElement >> text [
	^ labelElement text
]

{ #category : #accessing }
GtMessageOneLineSummaryElement >> text: aText [
	labelElement text: aText
]

{ #category : #'private - hooks' }
GtMessageOneLineSummaryElement >> unsubscribeFromMessageViewModel [
	super unsubscribeFromMessageViewModel.
	self messageViewModel unsubscribe: self
]

{ #category : #'private - updating' }
GtMessageOneLineSummaryElement >> updateElement [
	labelElement text: self messageViewModel contentOneLineSummary
]
