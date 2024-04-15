Class {
	#name : #GtLlmCompositeStepResult,
	#superclass : #GtLlmStepResult,
	#instVars : [
		'results',
		'instance'
	],
	#category : #'Gt4Llm-Code'
}

{ #category : #accessing }
GtLlmCompositeStepResult >> addResult: aResult [
	results add: aResult
]

{ #category : #accessing }
GtLlmCompositeStepResult >> asString [
	^ self results last asString
]

{ #category : #accessing }
GtLlmCompositeStepResult >> backgroundColor [
	^ self results
		ifEmpty: [ results last backgroundColor ]
		ifNotEmpty: [ self results last backgroundColor ]
]

{ #category : #accessing }
GtLlmCompositeStepResult >> children [
	^ results
]

{ #category : #accessing }
GtLlmCompositeStepResult >> content [
	^ self lastResult
]

{ #category : #accessing }
GtLlmCompositeStepResult >> foregroundColor [
	^ self results
		ifEmpty: [ results last foregroundColor ]
		ifNotEmpty: [ self results last foregroundColor ]
]

{ #category : #accessing }
GtLlmCompositeStepResult >> gtResultFor: aView [
	<gtView>
	^ aView forward
		title: 'Result';
		priority: 1;
		object: [ self results last ];
		view: #gtResultFor:
]

{ #category : #accessing }
GtLlmCompositeStepResult >> gtStepsFor: aView [
	<gtView>
	^ aView columnedTree expandAll
		title: 'Steps';
		priority: 2;
		items: [ results ];
		children: #children;
		column: 'Step'
			text: [ :aResult | aResult checker class stepName asRopedText background: aResult backgroundColor ];
		column: 'Result'
			text: [ :aResult | aResult isExecuted ifTrue: [ aResult content ] ifFalse: [ '' ] ]
]

{ #category : #accessing }
GtLlmCompositeStepResult >> hasError [
	^ results anySatisfy: #isError
]

{ #category : #accessing }
GtLlmCompositeStepResult >> initialize [
	super initialize.

	results := OrderedCollection new
]

{ #category : #accessing }
GtLlmCompositeStepResult >> instance [
	^ instance
]

{ #category : #accessing }
GtLlmCompositeStepResult >> instance: anObject [
	instance := anObject
]

{ #category : #accessing }
GtLlmCompositeStepResult >> isError [
	^ results anySatisfy: #isError
]

{ #category : #accessing }
GtLlmCompositeStepResult >> isExecuted [
	^ results anySatisfy: #isExecuted
]

{ #category : #accessing }
GtLlmCompositeStepResult >> lastResult [
	^ results ifEmpty: [ input ] ifNotEmpty: [ results last content ]
]

{ #category : #accessing }
GtLlmCompositeStepResult >> results [
	^ results
]
