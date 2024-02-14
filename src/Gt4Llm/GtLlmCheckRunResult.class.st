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
							aChecker name
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
GtLlmCheckRunResult >> gtCheckersFor: aView [
	<gtView>
	^ aView forward
		title: 'Checkers';
		priority: 2;
		object: [ self checkers ];
		view: #gtCheckersFor:
]

{ #category : #accessing }
GtLlmCheckRunResult >> gtResultsFor: aView [
	<gtView>
	^ aView columnedList
		title: 'Results';
		priority: 1;
		items: [ self checkers ];
		column: 'Check' text: #name;
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
