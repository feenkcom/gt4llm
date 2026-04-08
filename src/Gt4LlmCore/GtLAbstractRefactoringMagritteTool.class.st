"
Abstract superclass for refactoring tools that operate on a GtRBNamespace model.
"
Class {
	#name : #GtLAbstractRefactoringMagritteTool,
	#superclass : #GtLAbstractMagritteFunctionTool,
	#instVars : [
		'model'
	],
	#category : 'Gt4LlmCore-Tools'
}

{ #category : #testing }
GtLAbstractRefactoringMagritteTool class >> isAbstract [
	^ self name = #GtLAbstractRefactoringMagritteTool
]

{ #category : #accessing }
GtLAbstractRefactoringMagritteTool >> model [
	^ model
]

{ #category : #accessing }
GtLAbstractRefactoringMagritteTool >> model: aModel [
	model := aModel
]
