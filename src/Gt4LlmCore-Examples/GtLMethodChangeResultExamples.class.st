"
Common assertions for method change result examples.
"
Class {
	#name : #GtLMethodChangeResultExamples,
	#superclass : #GtLDomainObjectExamples,
	#category : 'Gt4LlmCore-Examples-Domain Objects'
}

{ #category : #asserting }
GtLMethodChangeResultExamples >> assertResultIsMethod: aResult [
	self assert: (aResult isMethodChangeResult).
	self assert: (aResult isClassChangeResult) not
]

{ #category : #asserting }
GtLMethodChangeResultExamples >> assertResultIsMethodAddition: aResult [
	self assert: (aResult isMethodAdditionResult).
	self assert: (aResult isMethodModificationResult) not.
	self assert: (aResult isMethodRemovalResult) not
]

{ #category : #asserting }
GtLMethodChangeResultExamples >> assertResultIsMethodModification: aResult [
	self assert: (aResult isMethodModificationResult).
	self assert: (aResult isMethodAdditionResult) not.
	self assert: (aResult isMethodRemovalResult) not
]

{ #category : #asserting }
GtLMethodChangeResultExamples >> assertResultIsMethodRemoval: aResult [
	self assert: (aResult isMethodRemovalResult).
	self assert: (aResult isMethodAdditionResult) not.
	self assert: (aResult isMethodModificationResult) not
]
