Class {
	#name : #GtLlmRenameFormatComponentInMethodController,
	#superclass : #GtRenameLiteralItemController,
	#instVars : [
		'assistantClass'
	],
	#category : 'Gt4Llm-GToolkit-UI'
}

{ #category : #accessing }
GtLlmRenameFormatComponentInMethodController >> assistantClass [
	^ assistantClass
]

{ #category : #accessing }
GtLlmRenameFormatComponentInMethodController >> assistantClass: anObject [
	assistantClass := anObject
]

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
		in: assistantClass
]
