"
I represent a variable added to a class.
"
Class {
	#name : #GtLVariableAdditionResult,
	#superclass : #GtLVariableChangeResult,
	#category : #'Gt4LlmCore-Magritte Objects'
}

{ #category : #accessing }
GtLVariableAdditionResult >> changeKindLabel [
	^ 'Added'
]

{ #category : #views }
GtLVariableAdditionResult >> gtViewChangeIcon [
	^ self class additionIcon
]

{ #category : #testing }
GtLVariableAdditionResult >> isVariableAdditionResult [
	^ true
]
