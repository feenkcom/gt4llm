"
I am the display options of the tools that apply a refactoring (applyRefactoring, renameClass). I add includeChanges: whether the response lists the applied changes at all.
"
Class {
	#name : #GtLRefactoringResultDisplayOptions,
	#superclass : #GtLRefactoringDisplayOptions,
	#instVars : [
		'includeChanges'
	],
	#category : #'Gt4LlmCore-Refactorings'
}

{ #category : #descriptions }
GtLRefactoringResultDisplayOptions >> descriptionContainer [
	^ super descriptionContainer
		comment: 'How much of the applied changes the response lists. includeSources and the limits apply to the groups; codeChanges are listed whole, without sources.';
		yourself
]

{ #category : #accessing }
GtLRefactoringResultDisplayOptions >> displayOptionItems [
	^ {'includeChanges' -> self includeChanges} , super displayOptionItems
]

{ #category : #accessing }
GtLRefactoringResultDisplayOptions >> includeChanges [
	^ includeChanges ifNil: [ true ]
]

{ #category : #accessing }
GtLRefactoringResultDisplayOptions >> includeChanges: aBooleanOrNil [
	includeChanges := aBooleanOrNil
]

{ #category : #descriptions }
GtLRefactoringResultDisplayOptions >> includeChangesDescription [
	<magritteDescription>
	^ MABooleanDescription new
		label: 'Include changes';
		accessor: #includeChanges;
		comment: 'Whether the response lists the applied changes; they are always listed when applying fails. Defaults to true.';
		beOptional
]

{ #category : #printing }
GtLRefactoringResultDisplayOptions >> printOptionsOn: aStream [
	super printOptionsOn: aStream.
	aStream
		nextPutAll: ', changes: ';
		print: self includeChanges
]
