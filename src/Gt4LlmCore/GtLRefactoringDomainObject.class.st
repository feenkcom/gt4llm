Class {
	#name : #GtLRefactoringDomainObject,
	#superclass : #GtLDomainObject,
	#instVars : [
		'model'
	],
	#category : #'Gt4LlmCore-Domain Objects'
}

{ #category : #accessing }
GtLRefactoringDomainObject >> model [
	^ model
]

{ #category : #accessing }
GtLRefactoringDomainObject >> model: anObject [
	model := anObject
]
