Class {
	#name : #GtLlmAlternativeCodeStep,
	#superclass : #GtLlmCodeStep,
	#instVars : [
		'alternatives'
	],
	#category : #'Gt4Llm-Code'
}

{ #category : #accessing }
GtLlmAlternativeCodeStep class >> stepName [
	^ 'Alternative'
]

{ #category : #accessing }
GtLlmAlternativeCodeStep >> addAlternative: aStep matching: aBlock [
	alternatives
		add: (GtLlmAlternativeChild new
				predicate: aBlock;
				step: aStep)
]

{ #category : #accessing }
GtLlmAlternativeCodeStep >> asNotExecuted [
	| result |
	result := GtLlmAlternativeStepResult new checker: self.
	self children do: [ :aChild | result addResult: aChild asNotExecuted ].
	^ result
]

{ #category : #accessing }
GtLlmAlternativeCodeStep >> children [
	^ alternatives
]

{ #category : #accessing }
GtLlmAlternativeCodeStep >> description [
	^ super description asRopedText
		append: ': ' asRopedText;
		append: ((alternatives size printString , ' alternatives') asRopedText
				foreground: BrGlamorousColors fadedTextColor)
]

{ #category : #accessing }
GtLlmAlternativeCodeStep >> initialize [
	super initialize.
	
	alternatives := OrderedCollection new
]

{ #category : #accessing }
GtLlmAlternativeCodeStep >> runStep: aContext [
	| alternativeContext executed |
	alternativeContext := GtLlmAlternativeStepResult new
			checker: self;
			input: aContext lastResult;
			instance: aContext instance.
	executed := false.

	alternatives
		do: [ :aPair | 
			(executed not and: [ aPair predicate value: alternativeContext ])
				ifTrue: [ aPair step runStep: alternativeContext.
					executed := true ]
				ifFalse: [ alternativeContext addResult: aPair step asNotExecuted ] ].

	executed
		ifTrue: [ aContext addResult: alternativeContext ]
		ifFalse: [ aContext
				addResult: (GtLlmStepStringError new
						checker: self;
						contentString: 'Did not find a matching code step') ]
]
