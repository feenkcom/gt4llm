Class {
	#name : #GtLlmChecker,
	#superclass : #Object,
	#category : #'Gt4Llm-Checker'
}

{ #category : #accessing }
GtLlmChecker class >> checkName [
	^ self subclassResponsibility
]

{ #category : #accessing }
GtLlmChecker >> check: aString [
	^ self subclassResponsibility
]

{ #category : #accessing }
GtLlmChecker >> checkName [
	^ self class checkName
]

{ #category : #accessing }
GtLlmChecker >> isExecutor [
	^ false
]

{ #category : #accessing }
GtLlmChecker >> isParser [
	^ false
]
