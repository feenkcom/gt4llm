"
I list a change that is neither a class, method nor Lepiter snippet change, such as a package change, by its target.
"
Class {
	#name : #GtLRefactoringOtherChangeEntry,
	#superclass : #GtLRefactoringChangeEntry,
	#instVars : [
		'target'
	],
	#category : #'Gt4LlmCore-Refactorings'
}

{ #category : #converting }
GtLRefactoringOtherChangeEntry >> addTargetPropertiesTo: aJsonObject [
	aJsonObject at: 'target' put: target
]

{ #category : #accessing }
GtLRefactoringOtherChangeEntry >> groupKind [
	^ #other
]

{ #category : #accessing }
GtLRefactoringOtherChangeEntry >> target [
	^ target
]

{ #category : #accessing }
GtLRefactoringOtherChangeEntry >> target: aString [
	target := aString
]
