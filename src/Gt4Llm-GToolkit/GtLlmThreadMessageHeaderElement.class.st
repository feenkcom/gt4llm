Class {
	#name : #GtLlmThreadMessageHeaderElement,
	#superclass : #BrHorizontalPane,
	#traits : 'TGtLlmWithThreadMessageViewModel',
	#classTraits : 'TGtLlmWithThreadMessageViewModel classTrait',
	#category : #'Gt4Llm-GToolkit-UI'
}

{ #category : #accessing }
GtLlmThreadMessageHeaderElement >> addActionElement [
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
GtLlmThreadMessageHeaderElement >> addSenderElement [
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
	self addActionElement
]
