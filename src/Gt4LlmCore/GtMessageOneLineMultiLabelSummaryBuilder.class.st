Class {
	#name : #GtMessageOneLineMultiLabelSummaryBuilder,
	#superclass : #Object,
	#instVars : [
		'labelElements',
		'attributesBuilder'
	],
	#category : #'Gt4LlmCore-UI - Support'
}

{ #category : #accessing }
GtMessageOneLineMultiLabelSummaryBuilder >> attributesBuilder [
	^ attributesBuilder
]

{ #category : #accessing }
GtMessageOneLineMultiLabelSummaryBuilder >> attributesBuilder: anObject [
	attributesBuilder := anObject
]

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
	| labelElement labelAptitude |
	labelAptitude := BrGlamorousLabelAptitude new.
	
	attributesBuilder ifNotNil: [ :aBuilder |
		labelAptitude attributesBuilder attributes: aBuilder attributes ].
			
	labelElement := BrLabel new
			hFitContentLimited;
			vFitContent;
			aptitude: labelAptitude;
			text: aString.
			
	labelElement userData at: #isMessageSummaryLabel put: true.

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
			text: '|'.
			
	labelElement userData at: #isMessageSummarySeparator put: true.

	labelElements add: labelElement
]

{ #category : #accessing }
GtMessageOneLineMultiLabelSummaryBuilder >> textStyler [
	^ textStyler
]

{ #category : #accessing }
GtMessageOneLineMultiLabelSummaryBuilder >> textStyler: anObject [
	textStyler := anObject
]
