Class {
	#name : #GtLlmCompositeChecker,
	#superclass : #GtLlmChecker,
	#instVars : [
		'checkers',
		'stopOnError'
	],
	#category : #'Gt4Llm-Checker'
}

{ #category : #accessing }
GtLlmCompositeChecker class >> defaultSmalltalkChecker [
	<gtExample>
	^ self forLanguage: 'Smalltalk'
]

{ #category : #accessing }
GtLlmCompositeChecker class >> forLanguage: aString [
	^ self new
		addChecker: (GtLlmParserChecker forLanguage: aString);
		addChecker: (GtLlmExecutorChecker forLanguage: aString)
]

{ #category : #accessing }
GtLlmCompositeChecker >> addChecker: aCheck [
	checkers add: aCheck
]

{ #category : #accessing }
GtLlmCompositeChecker >> check: aString [
	^ GtLlmCheckRun new
		checkers: self checkers;
		stopOnError: (stopOnError ifNil: [ true ]);
		run: aString
]

{ #category : #accessing }
GtLlmCompositeChecker >> checkers [
	^ checkers
]

{ #category : #accessing }
GtLlmCompositeChecker >> checkers: anObject [
	checkers := anObject
]

{ #category : #accessing }
GtLlmCompositeChecker >> doNotStopOnError [
	stopOnError := false
]

{ #category : #accessing }
GtLlmCompositeChecker >> executor [
	^ self checkers executor
]

{ #category : #accessing }
GtLlmCompositeChecker >> gtCheckFor: aView [
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
GtLlmCompositeChecker >> gtCheckersFor: aView [
	<gtView>
	^ aView forward
		title: 'Checkers';
		priority: 1;
		object: [ self checkers ];
		view: #gtCheckersFor:
]

{ #category : #accessing }
GtLlmCompositeChecker >> initialize [
	super initialize.
	
	checkers := GtLlmCheckerGroup new.
	stopOnError := true
]

{ #category : #accessing }
GtLlmCompositeChecker >> parsers [
	^ self checkers parsers
]

{ #category : #accessing }
GtLlmCompositeChecker >> stopOnError [
	stopOnError := true
]
