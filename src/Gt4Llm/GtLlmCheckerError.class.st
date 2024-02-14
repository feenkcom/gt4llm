Class {
	#name : #GtLlmCheckerError,
	#superclass : #GtLlmCheckerResult,
	#instVars : [
		'contentString'
	],
	#category : #'Gt4Llm-Checker'
}

{ #category : #accessing }
GtLlmCheckerError class >> prefix [
	^ 'LAST SCRIPT ERROR: '
]

{ #category : #accessing }
GtLlmCheckerError >> color [
	^ BrGlamorousColors errorBackgroundColor
]

{ #category : #accessing }
GtLlmCheckerError >> contentString [
	^ contentString
]

{ #category : #accessing }
GtLlmCheckerError >> contentString: anObject [
	contentString := anObject
]

{ #category : #accessing }
GtLlmCheckerError >> isError [
	^ true
]
