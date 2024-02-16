Class {
	#name : #GtLlmEvaluatedCodeWithExecutionErrorButtonAttribute,
	#superclass : #BrTextAdornmentAttribute,
	#instVars : [
		'result'
	],
	#category : #'Gt4Llm-Widgets'
}

{ #category : #initialization }
GtLlmEvaluatedCodeWithExecutionErrorButtonAttribute >> affect: aTBrTextEditorTextualPiece in: anEditorElement [
	<return: #SequenceableCollection of: #BlElement>
	| aButton |
	self checkRunResult hasErrors ifFalse: [ ^ #() ].

	aButton := self newBasicButton.

	^ aButton
		addAptitude: self newStyleAptitude;
		addAptitude: (self newDropdownAptitude: aButton);
		margin: (BlInsets left: 5 right: 2);
		yourself
]

{ #category : #accessing }
GtLlmEvaluatedCodeWithExecutionErrorButtonAttribute >> checkRunResult [
	<return: #GtLlmCheckRunResult>
	^ result value
]

{ #category : #initialization }
GtLlmEvaluatedCodeWithExecutionErrorButtonAttribute >> initialize [
	super initialize.
	self beAppend
]

{ #category : #testing }
GtLlmEvaluatedCodeWithExecutionErrorButtonAttribute >> mayHaveExternalReferences [
	^ true
]

{ #category : #initialization }
GtLlmEvaluatedCodeWithExecutionErrorButtonAttribute >> newBasicButton [
	| aLabel |
	aLabel := BrLabel new.

	^ aLabel
		fitContent;
		beSmallSize;
		text: (self checkRunResult executionResultObject printStringLimitedTo: 20);
		addAptitude: (BrGlamorousLabelAptitude new foreground: Color white);
		background: BrGlamorousColors errorBackgroundColor;
		geometry: (BlRoundedRectangleGeometry cornerRadius: 2);
		yourself
]

{ #category : #initialization }
GtLlmEvaluatedCodeWithExecutionErrorButtonAttribute >> newDropdownAptitude: aButton [
	| anAptitude |
	anAptitude := BrGlamorousWithDropdownAptitude
			handle: [ self newDropdownHandleButton ]
			content: [ self newDropdownContentElement: aButton ].

	^ anAptitude
]

{ #category : #initialization }
GtLlmEvaluatedCodeWithExecutionErrorButtonAttribute >> newDropdownContentElement: aButton [
	| aContainer anErrorElement |
	aContainer := BlElement new
			layout: BlFrameLayout new;
			padding: (BlInsets all: 5);
			border: (BlBorder paint: BrGlamorousColors errorBorderColor);
			geometry: (BlRoundedRectangleGeometry cornerRadius: 2);
			constraintsDo: [ :c | 
				c horizontal fitContent.
				c vertical fitContent ];
			when: GtPhlowObjectToSpawn
				do: [ :anEvent | 
					aButton
						fireEvent: (GtPhlowObjectToSpawn new
								previousSpawnEvent: anEvent;
								tool: anEvent tool;
								sourceElement: aButton;
								spawnDestination: self spawnDestination) ].

	anErrorElement := GtLlmCheckRunExecutionErrorElement new
			checkRunResult: self checkRunResult;
			hExact: 400;
			vFitContentLimited.
	aContainer addChild: anErrorElement.

	^ aContainer
]

{ #category : #initialization }
GtLlmEvaluatedCodeWithExecutionErrorButtonAttribute >> newDropdownHandleButton [
	| aButton |
	aButton := self newBasicButton.
	aButton background: BrGlamorousColors errorBorderColor.
	^ aButton
]

{ #category : #initialization }
GtLlmEvaluatedCodeWithExecutionErrorButtonAttribute >> newStyleAptitude [
	^ BrLazyStyleCommonAptitude new
		default: [ :aStyle | aStyle background: BrGlamorousColors errorBackgroundColor ];
		hovered: [ :aStyle | aStyle background: BrGlamorousColors errorBorderColor ]
]

{ #category : #accessing }
GtLlmEvaluatedCodeWithExecutionErrorButtonAttribute >> result [
	"Return {{gtClass:LeEvaluationResult}} with `#value` being {{gtClass:GtLlmCheckRunResult}}."

	<return: #LeEvaluationResult>
	^ result
]

{ #category : #accessing }
GtLlmEvaluatedCodeWithExecutionErrorButtonAttribute >> result: aResult [
	result := aResult
]
