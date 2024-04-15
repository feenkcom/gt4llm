Class {
	#name : #GtLlmStepStringSuccess,
	#superclass : #GtLlmStepSuccess,
	#instVars : [
		'contentString'
	],
	#category : #'Gt4Llm-Code'
}

{ #category : #accessing }
GtLlmStepStringSuccess >> contentString [
	^ contentString
]

{ #category : #accessing }
GtLlmStepStringSuccess >> contentString: anObject [
	contentString := anObject
]
