Class {
	#name : #GtLlmRenameFormatComponentInMethodController,
	#superclass : #GtRenameLiteralItemController,
	#instVars : [
		'tutorClass'
	],
	#category : #Gt4Llm
}

{ #category : #'as yet unclassified' }
GtLlmRenameFormatComponentInMethodController >> installValidation [
	renameAction forText
]

{ #category : #'as yet unclassified' }
GtLlmRenameFormatComponentInMethodController >> refactoringName [
	^ 'Rename Format Component'
]

{ #category : #'as yet unclassified' }
GtLlmRenameFormatComponentInMethodController >> rename: anOldName to: aNewName [
	| aModel |
	aModel := self createModel.
	^ GtLlmRenameFormatComponentRefactoring
		model: aModel
		rename: anOldName
		to: aNewName
		in: tutorClass
]

{ #category : #accessing }
GtLlmRenameFormatComponentInMethodController >> tutorClass [
	^ tutorClass
]

{ #category : #accessing }
GtLlmRenameFormatComponentInMethodController >> tutorClass: anObject [
	tutorClass := anObject
]
