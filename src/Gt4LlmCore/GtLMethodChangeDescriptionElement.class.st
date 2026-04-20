"
Description element for method-related code changes.
"
Class {
	#name : #GtLMethodChangeDescriptionElement,
	#superclass : #GtLCodeChangeDescriptionElement,
	#instVars : [
		'classNameLabel',
		'methodNameLabel'
	],
	#category : 'Gt4LlmCore-Summaries'
}

{ #category : #accessing }
GtLMethodChangeDescriptionElement >> changeResult: aChangeResult [
	self removeChildren.
	self addChild: (self 
		displayBehavior: aChangeResult targetMethodReference methodClassName).
	self addChild: (self 
		displayOperation: '>>').
	self addChild: (self 
		displayString: aChangeResult targetMethodReference methodName)
]

{ #category : #accessing }
GtLMethodChangeDescriptionElement >> initialize [
	super initialize.

	self fitContent.
	self vExact: 26.
	self alignCenterLeft.

	self addChild: (classNameLabel := self buildNewLabel).
	self
		addChild: (self buildNewLabel
			text: ('>>' asRopedText
					foreground: (Smalltalk ui theme textColor mixed: 0.1 with: Color gray))).
	self
		addChild: (methodNameLabel := self buildNewLabel)
]

{ #category : #updating }
GtLMethodChangeDescriptionElement >> updateForChangeObject: aChangeResult [
	classNameLabel text: (aChangeResult targetMethodReference methodClassName)
		asRopedText bold.
	methodNameLabel text: (aChangeResult targetMethodReference methodName)
]
