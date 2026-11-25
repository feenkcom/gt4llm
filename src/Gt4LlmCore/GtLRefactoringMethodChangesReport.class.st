"
I report the changed methods of a refactoring, sorted by class, side and selector.
"
Class {
	#name : #GtLRefactoringMethodChangesReport,
	#superclass : #GtLRefactoringChangesReport,
	#category : #'Gt4LlmCore-Refactorings'
}

{ #category : #private }
GtLRefactoringMethodChangesReport >> listKey [
	^ 'methods'
]

{ #category : #private }
GtLRefactoringMethodChangesReport >> sortBlock [
	"By class, instance side first, then by selector"

	^ [ :a :b | 
	a methodClassName = b methodClassName
		ifTrue: [ a classSide = b classSide
				ifTrue: [ a methodName <= b methodName ]
				ifFalse: [ b classSide ] ]
		ifFalse: [ a methodClassName <= b methodClassName ] ]
]
