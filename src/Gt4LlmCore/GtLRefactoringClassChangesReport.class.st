"
I report the changed classes of a refactoring, renamed classes first.
"
Class {
	#name : #GtLRefactoringClassChangesReport,
	#superclass : #GtLRefactoringChangesReport,
	#category : #'Gt4LlmCore-Refactorings'
}

{ #category : #private }
GtLRefactoringClassChangesReport >> listKey [
	^ 'classes'
]

{ #category : #private }
GtLRefactoringClassChangesReport >> sortBlock [
	"Renamed classes first"

	^ [ :a :b | 
	a isRename = b isRename
		ifTrue: [ a className <= b className ]
		ifFalse: [ a isRename ] ]
]
