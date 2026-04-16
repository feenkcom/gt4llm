"
Common assertions for class change result examples.
"
Class {
	#name : #GtLClassChangeResultExamples,
	#superclass : #GtLDomainObjectExamples,
	#category : #'Gt4LlmCore-Examples-Domain Objects'
}

{ #category : #asserting }
GtLClassChangeResultExamples >> assertResultIsClass: aResult [
	self assert: (aResult isClassChangeResult).
	self assert: (aResult isMethodChangeResult) not
]

{ #category : #asserting }
GtLClassChangeResultExamples >> assertResultIsClassAddition: aResult [
	self assert: (aResult isClassAdditionResult)
]

{ #category : #asserting }
GtLClassChangeResultExamples >> assertResultIsClassCommentChange: aResult [
	self assert: aResult status equals: 'changed'.
	self assert: (aResult isClassAdditionResult) not
]

{ #category : #asserting }
GtLClassChangeResultExamples >> assertResultIsClassModification: aResult [
	self assert: (aResult isClassAdditionResult) not
]

{ #category : #asserting }
GtLClassChangeResultExamples >> assertResultIsClassRemoval: aResult [
	self assert: aResult status equals: 'removed'.
	self assert: (aResult isClassAdditionResult) not
]
