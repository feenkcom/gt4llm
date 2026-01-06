Class {
	#name : #GtLMessageHeaderElement,
	#superclass : #BrHorizontalPane,
	#traits : 'TGtLWithMessageViewModel',
	#classTraits : 'TGtLWithMessageViewModel classTrait',
	#category : #'Gt4LlmCore-UI - Elements'
}

{ #category : #accessing }
GtLMessageHeaderElement >> addActionElement [
	| aFrame |
	aFrame := BrFrame new matchParent.

	aFrame
		padding: (BlInsets left: 0 right: 15);
		addChild: (BrLabel new
				hFitContentLimited;
				vFitContent;
				aptitude: BrGlamorousLabelAptitude new;
				beSmallSize;
				text: self messageViewModel contentText).
	self addChild: aFrame
]

{ #category : #accessing }
GtLMessageHeaderElement >> addSenderElement [
	self
		addChild: (BrLabel new
				hFitContentLimited;
				vFitContent;
				aptitude: (BrGlamorousLabelAptitude new
						foreground: BrGlamorousColors disabledButtonTextColor);
				beSmallSize;
				text: self messageViewModel senderText;
				addAptitude: (BrGlamorousWithExplicitTooltipAptitude
						text: (String
								streamContents: [ :s | self messageViewModel createdAt asLocal printSeparateDateAndTimeOn: s ])))
]

{ #category : #accessing }
GtLMessageHeaderElement >> initialize [
	super initialize.
	
	self vFitContent.
	self hMatchParent
]

{ #category : #'private - hooks' }
GtLMessageHeaderElement >> onMessageViewModelChanged [
	self updateElement
]

{ #category : #accessing }
GtLMessageHeaderElement >> updateElement [
	self removeChildren.
	
	self addSenderElement.
	self addActionElement
]
