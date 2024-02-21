Class {
	#name : #GtLlmRemoveMethodRefactoring,
	#superclass : #RBRemoveMethodRefactoring,
	#category : #'Gt4Llm-Refactorings'
}

{ #category : #preconditions }
GtLlmRemoveMethodRefactoring >> preconditions [
	^ selectors
		inject: self emptyCondition
		into: [ :cond :each | cond & (RBCondition definesSelector: each in: class) ]
]
