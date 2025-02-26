Class {
	#name : #GtLlmThreadMessageHeaderElement,
	#superclass : #BrHorizontalPane,
	#traits : 'TGtLlmWithThreadMessageViewModel',
	#classTraits : 'TGtLlmWithThreadMessageViewModel classTrait',
	#category : #Gt4Llm
}

{ #category : #accessing }
GtLlmThreadMessageHeaderElement >> addActionElement [
	| aFrame |
	aFrame := BrFrame new matchParent.

	aFrame
		padding: (BlInsets left: 15 right: 15);
		addChild: (BrLabel new
				hFitContentLimited;
				vFitContent;
				aptitude: (BrGlamorousLabelAptitude new
						foreground: BrGlamorousColors disabledButtonTextColor);
				beSmallSize;
				text: self threadMessageViewModel action;
				when: BlClickEvent
					do: [ :anEvent | anEvent target phlow spawnObject: self threadMessageViewModel actionModel ]).

	self addChild: aFrame
]

{ #category : #accessing }
GtLlmThreadMessageHeaderElement >> addSenderElement [
	self
		addChild: (BrLabel new
				hFitContentLimited;
				vFitContent;
				aptitude: (BrGlamorousLabelAptitude new
						foreground: BrGlamorousColors disabledButtonTextColor);
				beSmallSize;
				text: self threadMessageViewModel senderText)
]

{ #category : #accessing }
GtLlmThreadMessageHeaderElement >> addTimeElement [
	| timeTooltip |
	timeTooltip := BrGlamorousWithLabelTooltipAptitude new
			text: (String
					streamContents: [ :s | self threadMessageViewModel createdAt asLocal printSeparateDateAndTimeOn: s ]).

	self
		addChild: (BrLabel new
				updatingDateAndTimeModel;
				fitContent;
				beSmallSize;
				aptitude: (BrGlamorousLabelAptitude new
						foreground: BrGlamorousColors disabledButtonTextColor);
				addAptitude: timeTooltip;
				updatingDateAndTime: self threadMessageViewModel createdAt;
				yourself)
]

{ #category : #accessing }
GtLlmThreadMessageHeaderElement >> initialize [
	super initialize.
	
	self vFitContent.
	self hMatchParent
]

{ #category : #'private - hooks' }
GtLlmThreadMessageHeaderElement >> onThreadMessageViewModelChanged [
	self updateElement
]

{ #category : #accessing }
GtLlmThreadMessageHeaderElement >> updateElement [
	self removeChildren.
	
	self addSenderElement.
	self addTimeElement.
	self addActionElement
]
