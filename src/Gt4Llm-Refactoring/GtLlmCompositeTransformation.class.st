Class {
	#name : #GtLlmCompositeTransformation,
	#superclass : #RBRefactoring,
	#instVars : [
		'refactorings'
	],
	#category : #'Gt4Llm-Refactoring'
}

{ #category : #transforming }
GtLlmCompositeTransformation >> basicTransform [
	self refactorings do: [ :each | self performTransformation: each ]
]

{ #category : #private }
GtLlmCompositeTransformation >> performTransformation: aRefactoring [
	| changes |
	changes := RBCompositeRefactoryChange new.
	changes name: aRefactoring gtDescription.
	model performChange: changes around: [ aRefactoring primitiveExecute ]
]

{ #category : #preconditions }
GtLlmCompositeTransformation >> preconditions [
	^ RBCondition true
]

{ #category : #transforming }
GtLlmCompositeTransformation >> privateTransform [
	self basicTransform
]

{ #category : #accessing }
GtLlmCompositeTransformation >> refactorings [
	^ refactorings
]

{ #category : #accessing }
GtLlmCompositeTransformation >> refactorings: anObject [
	refactorings := anObject
]

{ #category : #transforming }
GtLlmCompositeTransformation >> transform [
	self basicTransform
]
