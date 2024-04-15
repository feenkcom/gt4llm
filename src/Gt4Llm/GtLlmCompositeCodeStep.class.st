Class {
	#name : #GtLlmCompositeCodeStep,
	#superclass : #GtLlmCodeStep,
	#instVars : [
		'steps'
	],
	#category : #'Gt4Llm-Code'
}

{ #category : #accessing }
GtLlmCompositeCodeStep class >> stepName [
	^ 'Composite'
]

{ #category : #accessing }
GtLlmCompositeCodeStep >> addStep: aStep [
	steps add: aStep
]

{ #category : #accessing }
GtLlmCompositeCodeStep >> asNotExecuted [
	| result |
	result := GtLlmCompositeStepResult new checker: self.
	self children do: [ :aChild | result addResult: aChild asNotExecuted ].
	^ result
]

{ #category : #accessing }
GtLlmCompositeCodeStep >> children [
	^ steps
]

{ #category : #accessing }
GtLlmCompositeCodeStep >> initialize [
	super initialize.
	
	steps := OrderedCollection new
]

{ #category : #accessing }
GtLlmCompositeCodeStep >> runStep: aContext [
	| compositeResult |
	self
		assert: steps isNotEmpty
		description: 'Steps of a composite cannot be empty.'.

	compositeResult := GtLlmCompositeStepResult new
			checker: self;
			input: aContext lastResult;
			instance: aContext instance.
	steps
		do: [ :aStep | 
			aStep runStep: compositeResult.
			compositeResult hasError
				ifTrue: [ aContext addResult: compositeResult.
					^ self ] ].
	aContext addResult: compositeResult
]
