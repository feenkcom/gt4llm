Class {
	#name : #GtLlmCheckRun,
	#superclass : #Object,
	#instVars : [
		'checkers',
		'stopOnError'
	],
	#category : #'Gt4Llm-Checker'
}

{ #category : #accessing }
GtLlmCheckRun >> checkers [
	^ checkers
]

{ #category : #accessing }
GtLlmCheckRun >> checkers: anObject [
	checkers := anObject
]

{ #category : #accessing }
GtLlmCheckRun >> doNotStopOnError [
	stopOnError := false
]

{ #category : #accessing }
GtLlmCheckRun >> initialize [
	stopOnError := true
]

{ #category : #accessing }
GtLlmCheckRun >> run: aString [
	| anIndex toCheckSize aResult |
	anIndex := 1.
	toCheckSize := self checkers size.
	aResult := GtLlmCheckRunResult new checkers: self checkers.

	[ anIndex <= toCheckSize ]
		whileTrue: [ | aChecker aCheckRun |
			aChecker := self checkers at: anIndex.

			aCheckRun := aChecker check: aString.

			aResult addResult: aCheckRun for: aChecker.

			(aCheckRun isError and: [ stopOnError ]) ifTrue: [ ^ aResult ].
			
			anIndex := anIndex + 1 ].

	^ aResult
]

{ #category : #accessing }
GtLlmCheckRun >> stopOnError [
	stopOnError := true
]

{ #category : #accessing }
GtLlmCheckRun >> stopOnError: aBoolean [
	stopOnError := aBoolean
]
