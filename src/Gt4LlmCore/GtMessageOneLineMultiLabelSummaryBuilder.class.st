Class {
	#name : #GtMessageOneLineMultiLabelSummaryBuilder,
	#superclass : #Object,
	#instVars : [
		'labelElements'
	],
	#category : 'Gt4LlmCore-UI - Support'
}

{ #category : #'gt - extensions' }
GtMessageOneLineMultiLabelSummaryBuilder >> gtLabelElementsFor: aView [
	<gtView>
	self labelElements ifNil: [ ^ aView empty ].

	^ aView columnedList
		title: 'Elements';
		items: [ self labelElements ifNil: [ #() ] ];
		column: 'Element' text: [ :each | each gtDisplayString ];
		column: 'Kind' text: [ :each | each class ]
]

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
	aString := String streamContents: [ :aStream | 
		aBlock value: (ZnIgnoreNewLineWriterStream on: aStream) ].
	
	self newWithText: aString
]

{ #category : #'api - building' }
GtMessageOneLineMultiLabelSummaryBuilder >> newWithText: aString [
	| labelElement |
	labelElement := BrLabel new
			hFitContentLimited;
			vFitContent;
			aptitude: BrGlamorousLabelAptitude"BrGlamorousShrinkingLabelAptitude" new;
			beSmallSize;
			text: aString.

	(labelElements isNotEmpty and: [ labelElements last isKindOf: BrLabel ])
		ifTrue: [ self textSeparator ].

	labelElements add: labelElement
]

{ #category : #'api - building' }
GtMessageOneLineMultiLabelSummaryBuilder >> textSeparator [
	| labelElement |
	labelElement := BrLabel new
			hFitContentLimited;
			vFitContent;
			aptitude: (BrGlamorousLabelAptitude new
					foreground: BrGlamorousColors disabledButtonTextColor);
			beSmallSize;
			text: '|'.

	labelElements add: labelElement
]
