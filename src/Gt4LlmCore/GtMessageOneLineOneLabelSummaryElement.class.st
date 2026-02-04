Class {
	#name : #GtMessageOneLineOneLabelSummaryElement,
	#superclass : #GtLBasicMessageElement,
	#traits : 'TBrSizeAdjustable',
	#classTraits : 'TBrSizeAdjustable classTrait',
	#instVars : [
		'labelElement'
	],
	#category : 'Gt4LlmCore-UI - Elements'
}

{ #category : #initialization }
GtMessageOneLineOneLabelSummaryElement >> defaultLayout [
	^ BlLinearLayout horizontal
]

{ #category : #initialization }
GtMessageOneLineOneLabelSummaryElement >> initialize [
	super initialize.

	self initializeLabelElement.

	self addChild: labelElement as: #'chat--message-content-label'.
	self addAptitude: (BrLayoutResizerAptitude new common: labelElement).

	self
		hFitContentLimited;
		vFitContent
]

{ #category : #initialization }
GtMessageOneLineOneLabelSummaryElement >> initializeLabelElement [
	labelElement := BrLabel new
			hFitContentLimited;
			vFitContent;
			aptitude: BrGlamorousLabelAptitude new;
			beSmallSize
]

{ #category : #'private - hooks' }
GtMessageOneLineOneLabelSummaryElement >> onMessageViewModelChanged [
	super onMessageViewModelChanged.
	self updateElement
]

{ #category : #'private - event handling' }
GtMessageOneLineOneLabelSummaryElement >> onMessageViewModelContentsChanged: anAnnouncement [
	self messageViewModel = anAnnouncement messageViewModel ifFalse: [ ^ self ].

	BlTaskAction enqueueElement: self action: [ self updateElement ]
]

{ #category : #'private - event handling' }
GtMessageOneLineOneLabelSummaryElement >> onThreadMessageViewModelChanged: anAnnouncement [
	BlTaskAction enqueueElement: self action: [ self updateElement ]
]

{ #category : #'private - hooks' }
GtMessageOneLineOneLabelSummaryElement >> subscribeToMessageViewModel [
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
GtMessageOneLineOneLabelSummaryElement >> text [
	^ labelElement text
]

{ #category : #accessing }
GtMessageOneLineOneLabelSummaryElement >> text: aText [
	labelElement text: aText
]

{ #category : #'private - hooks' }
GtMessageOneLineOneLabelSummaryElement >> unsubscribeFromMessageViewModel [
	super unsubscribeFromMessageViewModel.
	self messageViewModel unsubscribe: self
]

{ #category : #'private - updating' }
GtMessageOneLineOneLabelSummaryElement >> updateElement [
	labelElement text: self messageViewModel contentOneLineSummary
]
