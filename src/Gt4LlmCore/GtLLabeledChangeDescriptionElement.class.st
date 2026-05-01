Class {
	#name : #GtLLabeledChangeDescriptionElement,
	#superclass : #GtLCodeChangeDescriptionElement,
	#instVars : [
		'nameLabel'
	],
	#category : #'Gt4LlmCore-Summaries'
}

{ #category : #initialization }
GtLLabeledChangeDescriptionElement >> initialize [
	super initialize.

	self fitContent.
	self vExact: 26.
	self alignCenterLeft.

	self addChild: (nameLabel := self buildNewLabel).
	
]

{ #category : #updating }
GtLLabeledChangeDescriptionElement >> updateForString: aString [
	nameLabel text: aString
		asRopedText "bold".
]
