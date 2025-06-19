Class {
	#name : #GtLlmRenameFormatComponentRefactoring,
	#superclass : #RBMethodRefactoring,
	#instVars : [
		'oldName',
		'newName',
		'tutorClass'
	],
	#category : #'Gt4Llm-GToolkit'
}

{ #category : #'as yet unclassified' }
GtLlmRenameFormatComponentRefactoring class >> model: aModel rename: anOldName to: aNewName in: tutorClass [ 
	^ self new
		model: aModel;
		renameComponentFrom: anOldName to: aNewName in: tutorClass;
		yourself
]

{ #category : #transforming }
GtLlmRenameFormatComponentRefactoring >> basicTransform [
	self renameComponentReferences
]

{ #category : #'as yet unclassified' }
GtLlmRenameFormatComponentRefactoring >> preconditions [
	^ RBCondition withBlock: [ newName isNotEmpty ]
]

{ #category : #transforming }
GtLlmRenameFormatComponentRefactoring >> privateTransform [
	self basicTransform
]

{ #category : #'as yet unclassified' }
GtLlmRenameFormatComponentRefactoring >> renameComponentFrom: anOldName to: aNewName in: aClass [ 
	oldName := anOldName.
	newName := aNewName.
	tutorClass := aClass
]

{ #category : #'as yet unclassified' }
GtLlmRenameFormatComponentRefactoring >> renameComponentReferences [
	| rewriter |
	rewriter := RBParseTreeRewriter replaceLiteral: oldName with: newName.
	(self model classNamed: tutorClass name) withAllSubclasses
		do: [ :each | 
			each selectors
				do: [ :sel | 
					| method |
					method := each methodFor: sel.
					(rewriter executeTree: method ast)
						ifTrue: [ method compileTree: rewriter tree ] ] ]
]

{ #category : #transforming }
GtLlmRenameFormatComponentRefactoring >> transform [
	self basicTransform
]
