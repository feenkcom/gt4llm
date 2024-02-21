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
	^ 'The last script had a problem: '
]

{ #category : #accessing }
GtLlmCheckerError >> asString [
	^ self class prefix
		, '
```text
' , self contentString
		, '
```'
]

{ #category : #accessing }
GtLlmCheckerError >> backgroundColor [
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
GtLlmCheckerError >> foregroundColor [
	^ Color white
]

{ #category : #accessing }
GtLlmCheckerError >> isError [
	^ true
]
