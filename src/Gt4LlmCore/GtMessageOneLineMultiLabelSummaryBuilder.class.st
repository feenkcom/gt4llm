Class {
	#name : #GtMessageOneLineMultiLabelSummaryBuilder,
	#superclass : #Object,
	#instVars : [
		'labelElements'
	],
	#category : #'Gt4LlmCore-UI - Support'
}

{ #category : #initialization }
GtMessageOneLineMultiLabelSummaryBuilder >> initialize [
	super initialize.
	labelElements := OrderedCollection new
]

{ #category : #'api - accessing' }
GtMessageOneLineMultiLabelSummaryBuilder >> labelElements [
	^ labelElements
]

{ #category : #'api - building' }
GtMessageOneLineMultiLabelSummaryBuilder >> newTextFromStringStream: aBlock [
	| aString |
	aString := String streamContents: [ :aStream | aBlock value: aStream ].
	
	self newWithText: aString
]

{ #category : #'api - building' }
GtMessageOneLineMultiLabelSummaryBuilder >> newWithText: aString [
	| labelElement |
	labelElement := BrLabel new
			hFitContentLimited;
			vFitContent;
			aptitude: BrGlamorousLabelAptitude new;
			beSmallSize;
			text: aString.

	labelElements add: labelElement
]
