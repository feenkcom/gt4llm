Class {
	#name : #GtLlmAlternativeChild,
	#superclass : #Object,
	#instVars : [
		'predicate',
		'step'
	],
	#category : #'Gt4Llm-Code'
}

{ #category : #accessing }
GtLlmAlternativeChild >> asNotExecuted [
	^ self step asNotExecuted
]

{ #category : #accessing }
GtLlmAlternativeChild >> children [
	^ self step children
]

{ #category : #accessing }
GtLlmAlternativeChild >> description [
	^ self step description , ' when: ' asRopedText
		, (self predicate asString asRopedText
				foreground: BrGlamorousColors fadedTextColor)
]

{ #category : #accessing }
GtLlmAlternativeChild >> predicate [
	^ predicate
]

{ #category : #accessing }
GtLlmAlternativeChild >> predicate: anObject [
	predicate := anObject
]

{ #category : #accessing }
GtLlmAlternativeChild >> step [
	^ step
]

{ #category : #accessing }
GtLlmAlternativeChild >> step: anObject [
	step := anObject
]
