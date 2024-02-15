Class {
	#name : #GtLlmCheckPipeline,
	#superclass : #Object,
	#instVars : [
		'checkers',
		'stopOnError'
	],
	#category : #'Gt4Llm-Checker'
}

{ #category : #accessing }
GtLlmCheckPipeline class >> defaultPipeline [
	<gtExample>
	^ self forLanguage: 'Smalltalk'
]

{ #category : #accessing }
GtLlmCheckPipeline class >> forLanguage: aString [
	^ self new
		addChecker: (GtLlmParserChecker forLanguage: aString);
		addChecker: (GtLlmExecutorChecker forLanguage: aString)
]

{ #category : #accessing }
GtLlmCheckPipeline >> addChecker: aCheck [
	checkers add: aCheck
]

{ #category : #accessing }
GtLlmCheckPipeline >> check: aString [
	^ GtLlmCheckRun new
		checkers: self checkers;
		stopOnError: stopOnError;
		run: aString
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
GtLlmCheckPipeline >> doNotStopOnError [
	stopOnError := false
]

{ #category : #accessing }
GtLlmCheckPipeline >> executor [
	^ self checkers executor
]

{ #category : #accessing }
GtLlmCheckPipeline >> gtCheckFor: aView [
	<gtView>
	^ aView textEditor
		title: 'Check';
		priority: 2;
		aptitude: [ BrGlamorousCodeEditorAptitude ];
		text: [ '' ];
		actionButtonIcon: BrGlamorousVectorIcons play
			tooltip: 'Check'
			action: [ :aButton :aTab | 
				aButton phlow
					spawnObject: (self check: aTab viewContentElement children first text asString) ]
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
	
	checkers := GtLlmCheckerGroup new.
	stopOnError := true
]

{ #category : #accessing }
GtLlmCheckPipeline >> parsers [
	^ self checkers parsers
]

{ #category : #accessing }
GtLlmCheckPipeline >> stopOnError [
	stopOnError := true
]
