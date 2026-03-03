Class {
	#name : #GtMessageOneLineMultiLabelSummaryElement,
	#superclass : #GtLBasicMessageElement,
	#traits : 'TBrSizeAdjustable',
	#classTraits : 'TBrSizeAdjustable classTrait',
	#instVars : [
		'attributesBuilder'
	],
	#category : #'Gt4LlmCore-UI - Elements'
}

{ #category : #initialization }
GtMessageOneLineMultiLabelSummaryElement >> defaultLayout [
	^ BlLinearLayout horizontal alignTopLeft
]

{ #category : #initialization }
GtMessageOneLineMultiLabelSummaryElement >> initialize [
	super initialize.
	
	attributesBuilder := BlTextAttributesBuilder new.

	self
		addAptitude: (BrLayoutResizerAptitude new
				hMatchParentToFitContentLimited: [ self children ];
				vMatchParentToFitContent: [ self children ];
				fitContentToFitContent: [ self children ];
				fitContentLimitedToFitContentLimited: [ self children ];
				hExactToFitContentLimited: [ self children ];
				vExactToMatchParent: [ self children ]).

	self
		hFitContentLimited;
		vFitContent
]

{ #category : #'private - hooks' }
GtMessageOneLineMultiLabelSummaryElement >> onMessageViewModelChanged [
	super onMessageViewModelChanged.
	self updateElement
]

{ #category : #'private - event handling' }
GtMessageOneLineMultiLabelSummaryElement >> onMessageViewModelContentsChanged: anAnnouncement [
	self messageViewModel = anAnnouncement messageViewModel ifFalse: [ ^ self ].

	BlTaskAction enqueueElement: self action: [ self updateElement ]
]

{ #category : #'private - event handling' }
GtMessageOneLineMultiLabelSummaryElement >> onThreadMessageViewModelChanged: anAnnouncement [
	BlTaskAction enqueueElement: self action: [ self updateElement ]
]

{ #category : #'api - updating' }
GtMessageOneLineMultiLabelSummaryElement >> showProminentContentLabelElement [
	attributesBuilder foreground: self theme editor defaultTextForeground.
	self updateExistingLabelStylings
]

{ #category : #'api - updating' }
GtMessageOneLineMultiLabelSummaryElement >> showSubtleContentLabelElements [
	attributesBuilder foreground: self theme button disabledTextColor.
	self updateExistingLabelStylings.
]

{ #category : #'private - hooks' }
GtMessageOneLineMultiLabelSummaryElement >> subscribeToMessageViewModel [
	super subscribeToMessageViewModel.
	self messageViewModel weak
		when: GtLlmThreadMessageViewModelChanged
			send: #onThreadMessageViewModelChanged:
			to: self;
		when: GtLMessageViewModelContentsChanged
			send: #onMessageViewModelContentsChanged:
			to: self
]

{ #category : #'as yet unclassified' }
GtMessageOneLineMultiLabelSummaryElement >> text [
	"For testing purposes only"

	| aText |
	aText := '' asRopedText.
	self children
		do: [ :eachChild | aText append: eachChild text copy ]
		separatedBy: [ aText append: ' ' asRopedText ].
	^ aText
]

{ #category : #'private - hooks' }
GtMessageOneLineMultiLabelSummaryElement >> unsubscribeFromMessageViewModel [
	super unsubscribeFromMessageViewModel.
	self messageViewModel unsubscribe: self
]

{ #category : #'private - updating' }
GtMessageOneLineMultiLabelSummaryElement >> updateElement [
	| aBuilder |
	aBuilder := GtMessageOneLineMultiLabelSummaryBuilder new
		attributesBuilder: attributesBuilder.
	self messageViewModel contentOneLineMultiLabelSummaryWith: aBuilder.

	aBuilder labelElements
		do: [ :eachElement | 
			eachElement
				requestStyle;
				constraintsDo: [ :c | c linear vertical alignTop ] ].

	self
		removeChildren;
		addChildren: aBuilder labelElements
]

{ #category : #'private - updating' }
GtMessageOneLineMultiLabelSummaryElement >> updateExistingLabelStylings [
	self
		childrenDo: [ :eachChild | 
			eachChild userData
				at: #isMessageSummaryLabel
				ifPresent: [ :aBoolean | 
					eachChild aptitude attributesBuilder attributes: attributesBuilder attributes ]
				ifAbsent: [  ] ]
]
