Class {
	#name : #GtOllamaStatusSteps,
	#superclass : #GtLlmEntity,
	#instVars : [
		'steps'
	],
	#category : #'Gt4Ollama-Models'
}

{ #category : #accessing }
GtOllamaStatusSteps class >> from: anArray [
	^ self new steps: (anArray collect: [ :aDict | aDict at: 'status' ])
]

{ #category : #accessing }
GtOllamaStatusSteps >> gtStepsFor: aView [
	<gtView>
	^ aView list
		title: 'Steps';
		priority: 1;
		items: [ self steps ]
]

{ #category : #accessing }
GtOllamaStatusSteps >> steps [
	^ steps
]

{ #category : #accessing }
GtOllamaStatusSteps >> steps: anObject [
	steps := anObject
]
