Class {
	#name : #GtLlmCheckPipeline,
	#superclass : #Object,
	#instVars : [
		'checkers'
	],
	#category : #'Gt4Llm-Checker'
}

{ #category : #accessing }
GtLlmCheckPipeline class >> defaultPipeline [
	^ self new
		addChecker: GtLlmSmalltalkParserChecker new;
		addChecker: GtLlmSmalltalkExecutionChecker new
]

{ #category : #accessing }
GtLlmCheckPipeline >> addChecker: aCheck [
	checkers add: aCheck
]

{ #category : #accessing }
GtLlmCheckPipeline >> check: aString [
	^ GtLlmCheckRun new checkers: self checkers; run: aString
]

{ #category : #accessing }
GtLlmCheckPipeline >> checkers [
	^ checkers
]

{ #category : #accessing }
GtLlmCheckPipeline >> checkers: anObject [
	checkers := anObject
]

{ #category : #accessing }
GtLlmCheckPipeline >> gtCheckersFor: aView [
	<gtView>
	^ aView forward
		title: 'Checkers';
		priority: 1;
		object: [ self checkers ];
		view: #gtCheckersFor:
]

{ #category : #accessing }
GtLlmCheckPipeline >> initialize [
	super initialize.
	
	checkers := GtLlmCheckerGroup new
]
