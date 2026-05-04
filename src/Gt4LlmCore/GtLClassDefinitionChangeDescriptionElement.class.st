Class {
	#name : #GtLClassDefinitionChangeDescriptionElement,
	#superclass : #GtLCodeChangeDescriptionElement,
	#instVars : [
		'classNameLabel',
		'detailsLabel'
	],
	#category : #'Gt4LlmCore-Summaries'
}

{ #category : #initialization }
GtLClassDefinitionChangeDescriptionElement >> initialize [
	super initialize.

	self fitContent.
	self vExact: 26.
	self alignCenterLeft.

	self addChild: (classNameLabel := self buildNewLabel).
	self
		addChild: (detailsLabel := self buildNewLabel
			text: '').
	
]

{ #category : #updating }
GtLClassDefinitionChangeDescriptionElement >> updateForChangeHistory: aClassHistory [
	classNameLabel text: (aClassHistory targetClassName)
		asRopedText
]

{ #category : #updating }
GtLClassDefinitionChangeDescriptionElement >> updateForChangeObject: aChangeResult [
	classNameLabel text: (aChangeResult targetClassName)
		asRopedText
]

{ #category : #updating }
GtLClassDefinitionChangeDescriptionElement >> updateForClassDefinitionChangeHistory: aClassHistory [
	classNameLabel text: (aClassHistory targetClassName) asRopedText.
	detailsLabel text: ('definition' asRopedText
					foreground: (Smalltalk ui theme textColor mixed: 0.1 with: Color gray))
]
