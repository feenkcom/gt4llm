Class {
	#name : #GtLlmRefactoringToolForClassReferences,
	#superclass : #GtLlmAbstractFunctionTool,
	#instVars : [
		'model'
	],
	#category : #'Gt4Llm-Refactoring'
}

{ #category : #'llm-generated' }
GtLlmRefactoringToolForClassReferences >> description [
	^ 'Search the image for the references to the given class'
]

{ #category : #'llm-generated' }
GtLlmRefactoringToolForClassReferences >> model [
	^ model
]

{ #category : #'llm-generated' }
GtLlmRefactoringToolForClassReferences >> model: aModel [
	model := aModel
]

{ #category : #'llm-generated' }
GtLlmRefactoringToolForClassReferences >> name [
	^ 'rbClassReferences'
]

{ #category : #'llm-generated' }
GtLlmRefactoringToolForClassReferences >> parameters [
	^ #('className')
]

{ #category : #'llm-generated' }
GtLlmRefactoringToolForClassReferences >> privatePerformToolCall: aToolCall [
	| arguments className targetClass |
	self model ifNil: [ ^ 'Model not provided' ].
	arguments := aToolCall arguments ifNil: [ Dictionary new ].
	className := arguments at: 'className' ifAbsent: [ ^ 'Class name not provided' ].
	targetClass := self model classNamed: className.
	targetClass ifNil: [ ^ 'Class not found' ].
	^ String
		streamContents: [ :stream |
			self model
				allReferencesToClass: targetClass
				do: [ :each |
					stream << each modelClass name.
					each modelClass isMeta ifTrue: [ stream << ' class' ].
					stream << '>>#' << each selector << String cr ] ]
]
