Class {
	#name : #GtLClassDefinitionChangeDescriptionElement,
	#superclass : #GtLCodeChangeDescriptionElement,
	#instVars : [
		'classNameLabel'
	],
	#category : 'Gt4LlmCore-Summaries'
}

{ #category : #initialization }
GtLClassDefinitionChangeDescriptionElement >> initialize [
	super initialize.

	self fitContent.
	self vExact: 26.
	self alignCenterLeft.

	self addChild: (classNameLabel := self buildNewLabel).
	
]

{ #category : #updating }
GtLClassDefinitionChangeDescriptionElement >> updateForChangeHistory: aClassHistory [
	classNameLabel text: (aClassHistory targetClassName)
		asRopedText "bold".
]

{ #category : #updating }
GtLClassDefinitionChangeDescriptionElement >> updateForChangeObject: aChangeResult [
	classNameLabel text: (aChangeResult targetClassName)
		asRopedText "bold".
]
