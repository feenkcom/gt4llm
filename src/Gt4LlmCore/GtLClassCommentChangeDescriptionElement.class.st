Class {
	#name : #GtLClassCommentChangeDescriptionElement,
	#superclass : #GtLCodeChangeDescriptionElement,
	#instVars : [
		'classNameLabel'
	],
	#category : 'Gt4LlmCore-Summaries'
}

{ #category : #initialization }
GtLClassCommentChangeDescriptionElement >> initialize [
	super initialize.

	self fitContent.
	self vExact: 26.
	self alignCenterLeft.

	self addChild: (classNameLabel := self buildNewLabel).
	self
		addChild: (self buildNewLabel
			text: ('comment' asRopedText
					foreground: (Smalltalk ui theme textColor mixed: 0.1 with: Color gray))).
	
]

{ #category : #updating }
GtLClassCommentChangeDescriptionElement >> updateForChangeObject: aChangeResult [
	classNameLabel text: (aChangeResult targetClassName)
		asRopedText "bold".
]
