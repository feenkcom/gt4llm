Class {
	#name : #GtLlmCodeStepContext,
	#superclass : #Object,
	#instVars : [
		'input',
		'results'
	],
	#category : #'Gt4Llm-Code'
}

{ #category : #accessing }
GtLlmCodeStepContext >> addResult: aResult [
	results add: aResult
]

{ #category : #accessing }
GtLlmCodeStepContext >> gtInputFor: aView [
	<gtView>
	^ aView forward
		title: 'Input';
		priority: 2;
		object: [ self input ];
		view: #gtLiveFor:
]

{ #category : #accessing }
GtLlmCodeStepContext >> gtOutputFor: aView [
	<gtView>
	^ aView forward
		title: 'Output';
		priority: 3;
		object: [ self lastResult ];
		view: #gtLiveFor:
]

{ #category : #accessing }
GtLlmCodeStepContext >> gtStepsFor: aView [
	<gtView>
	^ aView columnedTree
		title: 'Steps';
		priority: 1;
		items: [ results ];
		children: #children;
		column: 'Step'
			text: [ :aResult | aResult checker class stepName asRopedText background: aResult backgroundColor ];
		column: 'Result' text: #content
]

{ #category : #accessing }
GtLlmCodeStepContext >> hasError [
	^ results last isError
]

{ #category : #accessing }
GtLlmCodeStepContext >> initialize [
	super initialize.
	
	results := OrderedCollection new
]

{ #category : #accessing }
GtLlmCodeStepContext >> input [
	^ input
]

{ #category : #accessing }
GtLlmCodeStepContext >> input: anObject [
	input := anObject
]

{ #category : #accessing }
GtLlmCodeStepContext >> lastResult [
	^ results ifEmpty: [ self input ] ifNotEmpty: [ results last content ]
]

{ #category : #accessing }
GtLlmCodeStepContext >> realContext [
	^ self
]
