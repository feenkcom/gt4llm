Class {
	#name : #GtLlmActionThreadMessageHeaderElement,
	#superclass : #GtLlmThreadMessageHeaderElement,
	#category : #'Gt4OpenAI-Widgets'
}

{ #category : #accessing }
GtLlmActionThreadMessageHeaderElement >> addActionElement [
	| aFrame |
	aFrame := BrFrame new matchParent.

	self threadMessageViewModel isAssistantRole ifFalse: [ ^ aFrame ].

	self
		addChild: (aFrame
				padding: (BlInsets left: 15 right: 15);
				addChild: (BrLabel new
						hFitContentLimited;
						vFitContent;
						aptitude: (BrGlamorousLabelAptitude new
								foreground: BrGlamorousColors disabledButtonTextColor);
						beSmallSize;
						text: (self threadMessageViewModel ancestor contentText lines
								ifEmpty: [ '' ]
								ifNotEmpty: #first)))
]

{ #category : #accessing }
GtLlmActionThreadMessageHeaderElement >> updateElement [
	self removeChildren.
	
	self addSenderElement.
	self addTimeElement.
	self addActionElement
]
