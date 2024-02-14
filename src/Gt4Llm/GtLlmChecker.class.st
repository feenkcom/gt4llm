Class {
	#name : #GtLlmChecker,
	#superclass : #Object,
	#category : #'Gt4Llm-Checker'
}

{ #category : #accessing }
GtLlmChecker >> check: aString [
	^ self subclassResponsibility
]

{ #category : #accessing }
GtLlmChecker >> name [
	^ self subclassResponsibility
]
