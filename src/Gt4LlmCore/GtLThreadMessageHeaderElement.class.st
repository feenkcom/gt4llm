Class {
	#name : #GtLThreadMessageHeaderElement,
	#superclass : #BrHorizontalPane,
	#traits : 'TGtLWithThreadMessageViewModel',
	#classTraits : 'TGtLWithThreadMessageViewModel classTrait',
	#category : #'Gt4LlmCore-UI'
}

{ #category : #accessing }
GtLThreadMessageHeaderElement >> addActionElement [
	| aFrame |
	aFrame := BrFrame new matchParent.

	aFrame
		padding: (BlInsets left: 0 right: 15);
		addChild: (BrLabel new
				hFitContentLimited;
				vFitContent;
				aptitude: BrGlamorousLabelAptitude new;
				beSmallSize;
				text: self threadMessageViewModel actionString).
	self addChild: aFrame
]

{ #category : #accessing }
GtLThreadMessageHeaderElement >> addSenderElement [
	self
		addChild: (BrLabel new
				hFitContentLimited;
				vFitContent;
				aptitude: (BrGlamorousLabelAptitude new
						foreground: BrGlamorousColors disabledButtonTextColor);
				beSmallSize;
				text: self threadMessageViewModel senderText
						, (self threadMessageViewModel hasAction ifTrue: [ ':' ] ifFalse: [ '' ]);
				addAptitude: (BrGlamorousWithExplicitTooltipAptitude
						text: (String
								streamContents: [ :s | self threadMessageViewModel createdAt asLocal printSeparateDateAndTimeOn: s ])))
]

{ #category : #accessing }
GtLThreadMessageHeaderElement >> initialize [
	super initialize.
	
	self vFitContent.
	self hMatchParent
]

{ #category : #'private - hooks' }
GtLThreadMessageHeaderElement >> onThreadMessageViewModelChanged [
	self updateElement
]

{ #category : #accessing }
GtLThreadMessageHeaderElement >> updateElement [
	self removeChildren.
	
	self addSenderElement.
	self addActionElement
]
