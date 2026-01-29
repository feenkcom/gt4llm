Class {
	#name : #GtLRefactoringDomainObject,
	#superclass : #GtLDomainObject,
	#instVars : [
		'model'
	],
	#category : 'Gt4LlmCore-Domain Objects'
}

{ #category : #visiting }
GtLRefactoringDomainObject >> acceptVisitor: aVisitor [
	^ aVisitor visitRefactoringDomainObject: self
]

{ #category : #accessing }
GtLRefactoringDomainObject >> model [
	^ model
]

{ #category : #accessing }
GtLRefactoringDomainObject >> model: anObject [
	model := anObject
]
