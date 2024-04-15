Class {
	#name : #GtLlmCodeStep,
	#superclass : #Object,
	#instVars : [
		'instance'
	],
	#category : #'Gt4Llm-Code'
}

{ #category : #accessing }
GtLlmCodeStep class >> stepName [
	^ self subclassResponsibility
]

{ #category : #accessing }
GtLlmCodeStep >> asNotExecuted [
	^ (GtLlmStepNotExecuted new checker: self)
]

{ #category : #accessing }
GtLlmCodeStep >> children [
	^ {}
]

{ #category : #accessing }
GtLlmCodeStep >> gtCompositionFor: aView [
	<gtView>
	^ aView tree
		title: 'Composition';
		priority: 1;
		items: [ {self} ];
		children: #children;
		itemText: [ :anItem | anItem class stepName ]
]

{ #category : #accessing }
GtLlmCodeStep >> instance [
	^ instance
]

{ #category : #accessing }
GtLlmCodeStep >> instance: anObject [
	instance := anObject
]

{ #category : #accessing }
GtLlmCodeStep >> runOn: anInput [
	| context |
	context := GtLlmCompositeStepResult new
			input: anInput;
			instance: self instance.
	self runStep: context.
	^ context
]

{ #category : #accessing }
GtLlmCodeStep >> runStep: aContext [
	^ self subclassResponsibility
]
