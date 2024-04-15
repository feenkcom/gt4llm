Class {
	#name : #GtLlmStepError,
	#superclass : #GtLlmStepResult,
	#instVars : [
		'contentString'
	],
	#category : #'Gt4Llm-Code'
}

{ #category : #accessing }
GtLlmStepError class >> prefix [
	^ 'The last script had a problem: '
]

{ #category : #accessing }
GtLlmStepError >> asString [
	^ self class prefix
		, '
```text
' , self contentString
		, '
```'
]

{ #category : #accessing }
GtLlmStepError >> backgroundColor [
	^ BrGlamorousColors errorBackgroundColor
]

{ #category : #accessing }
GtLlmStepError >> contentString [
	^ contentString
]

{ #category : #accessing }
GtLlmStepError >> contentString: anObject [
	contentString := anObject
]

{ #category : #accessing }
GtLlmStepError >> foregroundColor [
	^ Color white
]

{ #category : #accessing }
GtLlmStepError >> isError [
	^ true
]
