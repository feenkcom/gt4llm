Class {
	#name : #GtLlmRenameFormatComponentRefactoring,
	#superclass : #RBMethodRefactoring,
	#instVars : [
		'oldName',
		'newName',
		'tutorClass'
	],
	#category : #'Gt4Llm-Refactorings'
}

{ #category : #'as yet unclassified' }
GtLlmRenameFormatComponentRefactoring class >> model: aModel rename: anOldName to: aNewName in: tutorClass [ 
	^ self new
		model: aModel;
		renameComponentFrom: anOldName to: aNewName in: tutorClass;
		yourself
]

{ #category : #'as yet unclassified' }
GtLlmRenameFormatComponentRefactoring >> preconditions [
	^ RBCondition withBlock: [ newName isNotEmpty ]
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
	self halt.
	rewriter := RBParseTreeRewriter new.
	rewriter
		replace: oldName asString storeString
		with: newName asString storeString
		when: [ :node | node gtIsFormatComponentIn: tutorClass ].
	(self model classNamed: tutorClass name) withAllSubclasses
		do: [ :each | 
			each selectors
				do: [ :sel | 
					| method |
					method := each methodFor: sel.
					(rewriter executeTree: method ast)
						ifTrue: [ method compileTree: rewriter tree ] ] ]
]

{ #category : #'as yet unclassified' }
GtLlmRenameFormatComponentRefactoring >> transform [
	self renameComponentReferences.
	(self model classNamed: tutorClass name)
		compile: ((tutorClass new formatComponentNamed: oldName) definingMethod sourceCode
				copyReplaceAll: 'name: ' , oldName storeString
				with: 'name: ' , newName storeString)
]
