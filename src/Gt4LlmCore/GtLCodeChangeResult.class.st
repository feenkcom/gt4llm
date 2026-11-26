Class {
	#name : #GtLCodeChangeResult,
	#superclass : #GtLChangeResult,
	#category : #'Gt4LlmCore-Magritte Objects'
}

{ #category : #accessing }
GtLCodeChangeResult >> addedVariableNamesFor: aVariableType [
	^ #()
]

{ #category : #testing }
GtLCodeChangeResult >> isClassChangeResult [
	^ false
]

{ #category : #testing }
GtLCodeChangeResult >> isClassModificationResult [
	^ false
]

{ #category : #testing }
GtLCodeChangeResult >> isClassRemovalResult [
	^ false
]

{ #category : #testing }
GtLCodeChangeResult >> isClassRenameResult [
	^ false
]

{ #category : #testing }
GtLCodeChangeResult >> isMethodChangeResult [
	^ false
]

{ #category : #testing }
GtLCodeChangeResult >> isVariableAdditionResult [
	^ false
]

{ #category : #testing }
GtLCodeChangeResult >> isVariableRemovalResult [
	^ false
]

{ #category : #refactoring }
GtLCodeChangeResult >> llmChangeEntry [
	"Return the entry that lists me in the groups of changes of an applied refactoring"

	^ GtLRefactoringOtherChangeEntry new
		target: self llmChangeTarget;
		kind: self llmChangeKind;
		yourself
]

{ #category : #refactoring }
GtLCodeChangeResult >> llmChangeKind [
	"Return a short label of what changed when a refactoring was applied, such as 'added method' or 'renamed class'"

	^ 'changed'
]

{ #category : #refactoring }
GtLCodeChangeResult >> llmChangeTarget [
	"Return the method signature or class name that changed"

	^ self targetClassName asString
]

{ #category : #accessing }
GtLCodeChangeResult >> removedVariableNamesFor: aVariableType [
	^ #()
]
