Class {
	#name : #GtLRefactoringDomainObject,
	#superclass : #Object,
	#instVars : [
		'model'
	],
	#category : #'Gt4LlmCore-Domain Objects'
}

{ #category : #testing }
GtLRefactoringDomainObject >> isErrorDomainObject [
	"Return true if the domain object represents some kind of failure or exception,
	instead of an expected domain object."

	^ false
]

{ #category : #accessing }
GtLRefactoringDomainObject >> model [
	^ model
]

{ #category : #accessing }
GtLRefactoringDomainObject >> model: anObject [
	model := anObject
]
