Class {
	#name : #GtLlmEvaluatedCodePreviewAttribute,
	#superclass : #BrTextAdornmentAttribute,
	#instVars : [
		'checkRunResultViewModel'
	],
	#category : #'Gt4Llm-Widgets'
}

{ #category : #initialization }
GtLlmEvaluatedCodePreviewAttribute >> affect: aTBrTextEditorTextualPiece in: anEditorElement [
	<return: #SequenceableCollection of: #BlElement>
	| aButton |
	aButton := self newBasicButton.

	^ aButton
		addAptitude: self newStyleAptitude;
		addAptitude: (self newDropdownAptitude: aButton);
		margin: (BlInsets left: 5 right: 2);
		yourself
]

{ #category : #accessing }
GtLlmEvaluatedCodePreviewAttribute >> checkRunResult [
	^ checkRunResultViewModel checkRunResult
]

{ #category : #accessing }
GtLlmEvaluatedCodePreviewAttribute >> checkRunResultViewModel [
	^ checkRunResultViewModel
]

{ #category : #accessing }
GtLlmEvaluatedCodePreviewAttribute >> checkRunResultViewModel: anObject [
	checkRunResultViewModel := anObject
]

{ #category : #initialization }
GtLlmEvaluatedCodePreviewAttribute >> configureAnchoredAptitude: anAnchoredAptitude [
	self lastCheckResult backgroundColor
		ifNotNil: [ :aColor | 
			anAnchoredAptitude border: aColor darker.
			anAnchoredAptitude background: aColor darker ]
]

{ #category : #initialization }
GtLlmEvaluatedCodePreviewAttribute >> initialize [
	super initialize.
	self beAppend
]

{ #category : #accessing }
GtLlmEvaluatedCodePreviewAttribute >> lastCheckResult [
	<return: #GtLlmStepResult>
	^ self checkRunResult
]

{ #category : #testing }
GtLlmEvaluatedCodePreviewAttribute >> mayHaveExternalReferences [
	^ true
]

{ #category : #initialization }
GtLlmEvaluatedCodePreviewAttribute >> newBasicButton [
	| aLabel |
	aLabel := BrLabel new.

	^ aLabel
		fitContent;
		beSmallSize;
		text: self lastCheckResult summaryString;
		addAptitude: (BrGlamorousLabelAptitude new foreground: self lastCheckResult foregroundColor);
		background: self lastCheckResult backgroundColor;
		geometry: (BlRoundedRectangleGeometry cornerRadius: 2);
		yourself
]

{ #category : #initialization }
GtLlmEvaluatedCodePreviewAttribute >> newDropdownAptitude: aButton [
	| anAptitude |
	anAptitude := BrGlamorousWithDropdownAptitude
			handle: [ self newDropdownHandleButton ]
			content: [ self newDropdownContentElement: aButton ]
			aptitudeDo: [ :anAnchoredAptitude | 
				self configureAnchoredAptitude: anAnchoredAptitude ].

	^ anAptitude
]

{ #category : #initialization }
GtLlmEvaluatedCodePreviewAttribute >> newDropdownContentElement: aButton [
	| anErrorElement |
	anErrorElement := GtLlmCheckRunExecutionPreviewElement new
			checkRunResultViewModel: self checkRunResultViewModel;
			background: Color white;
			padding: (BlInsets all: 5);
			hExact: 400;
			vFitContentLimited;
			when: GtPhlowObjectToSpawn
				do: [ :anEvent | 
					aButton
						fireEvent: (GtPhlowObjectToSpawn new
								previousSpawnEvent: anEvent;
								tool: anEvent tool;
								sourceElement: aButton;
								spawnDestination: self spawnDestination) ].

	^ anErrorElement
]

{ #category : #initialization }
GtLlmEvaluatedCodePreviewAttribute >> newDropdownHandleButton [
	| aButton |
	aButton := self newBasicButton.
	aButton background: self lastCheckResult backgroundColor darker.
	^ aButton
]

{ #category : #initialization }
GtLlmEvaluatedCodePreviewAttribute >> newStyleAptitude [
	^ BrLazyStyleCommonAptitude new
		default: [ :aStyle | aStyle background: self lastCheckResult backgroundColor ];
		hovered: [ :aStyle | aStyle background: self lastCheckResult backgroundColor darker ]
]

{ #category : #initialization }
GtLlmEvaluatedCodePreviewAttribute >> spawnDestination [
	^ GtPhlowSpawnDesiredDestination defaultDestination
]
