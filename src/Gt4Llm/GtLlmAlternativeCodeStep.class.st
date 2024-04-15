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
	alternatives add: aBlock -> aStep
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
	^ alternatives collect: #value
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
			(executed not and: [ aPair key value: alternativeContext ])
				ifTrue: [ aPair value runStep: alternativeContext.
					executed := true ]
				ifFalse: [ alternativeContext
						addResult: aPair value asNotExecuted ] ].

	executed
		ifTrue: [ aContext addResult: alternativeContext ]
		ifFalse: [ aContext
				addResult: (GtLlmStepStringError new
						checker: self;
						contentString: 'Did not find a matching code step') ]
]
