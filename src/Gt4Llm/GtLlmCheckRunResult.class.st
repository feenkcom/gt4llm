Class {
	#name : #GtLlmCheckRunResult,
	#superclass : #Object,
	#instVars : [
		'checkers',
		'results'
	],
	#category : #'Gt4Llm-Checker'
}

{ #category : #accessing }
GtLlmCheckRunResult >> addResult: aResult for: aChecker [
	self results at: aChecker put: aResult
]

{ #category : #accessing }
GtLlmCheckRunResult >> asString [
	^ self prefix
		, '
Output of checks:
'
		, (Character lf
				join: (self checkers
						collect: [ :aChecker | 
							aChecker checkName
								, ':
' , (self results at: aChecker) asString ]))
]

{ #category : #accessing }
GtLlmCheckRunResult >> checkers [
	^ checkers
]

{ #category : #accessing }
GtLlmCheckRunResult >> checkers: anObject [
	checkers := anObject.
	self resetResults
]

{ #category : #accessing }
GtLlmCheckRunResult >> executionResult [
	^ (self results at: self checkers executor) content
]

{ #category : #accessing }
GtLlmCheckRunResult >> gtCheckersFor: aView [
	<gtView>
	^ aView forward
		title: 'Checkers';
		priority: 3;
		object: [ self checkers ];
		view: #gtCheckersFor:
]

{ #category : #accessing }
GtLlmCheckRunResult >> gtErrorsFor: aView [
	<gtView>
	self hasErrors ifFalse: [ ^ aView empty ].

	^ aView columnedList
		title: 'Errors';
		priority: 1;
		items: [ self checkers select: [ :aChecker | (self results at: aChecker) isError ] ];
		column: 'Check' text: #checkName;
		column: 'Exception'
			text: [ :aChecker | 
				| state |
				state := self results at: aChecker.
				state content ];
		send: [ :aChecker | self results at: aChecker ]
]

{ #category : #accessing }
GtLlmCheckRunResult >> gtExecutionResultFor: aView [
	<gtView>
	self hasErrors ifTrue: [ ^ aView empty ].

	^ aView forward
		title: 'Execution result';
		priority: 1;
		object: [ self executionResult ];
		view: #gtLiveFor:;
		actionButtonIcon: BrGlamorousVectorIcons inspect
			tooltip: 'Inspect result'
			action: [ :aButton | aButton phlow spawnObject: self executionResult ]
]

{ #category : #accessing }
GtLlmCheckRunResult >> gtResultsFor: aView [
	<gtView>
	^ aView columnedList
		title: 'Results';
		priority: 2;
		items: [ self checkers ];
		column: 'Check' text: #checkName;
		column: 'State'
			stencil: [ :aChecker | 
				| state |
				state := self results at: aChecker.
				state asElement margin: (BlInsets left: 12) ]
			width: 50;
		send: [ :aChecker | self results at: aChecker ]
]

{ #category : #accessing }
GtLlmCheckRunResult >> hasErrors [
	^ self results values anySatisfy: #isError
]

{ #category : #accessing }
GtLlmCheckRunResult >> prefix [
	^ self hasErrors
		ifTrue: [ GtLlmCheckerError prefix ]
		ifFalse: [ GtLlmCheckerSuccess prefix ]
]

{ #category : #accessing }
GtLlmCheckRunResult >> resetResults [
	self
		results: (self checkers
				collect: [ :aChecker | aChecker -> (GtLlmCheckerNotExecuted new checker: aChecker) ])
				asDictionary
]

{ #category : #accessing }
GtLlmCheckRunResult >> results [
	^ results
]

{ #category : #accessing }
GtLlmCheckRunResult >> results: anObject [
	results := anObject
]
