Class {
	#name : #GtLCodeTransformationSpecification,
	#superclass : #Object,
	#category : #'Gt4LlmCore-Formats'
}

{ #category : #'as yet unclassified' }
GtLCodeTransformationSpecification class >> isConcrete [
	^ false
]

{ #category : #'as yet unclassified' }
GtLCodeTransformationSpecification >> asRefactoringIn: aNamespace [
	^ self subclassResponsibility
]
