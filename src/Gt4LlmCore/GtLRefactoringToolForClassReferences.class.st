Class {
	#name : #GtLRefactoringToolForClassReferences,
	#superclass : #GtLAbstractFunctionTool,
	#instVars : [
		'model'
	],
	#category : #'Gt4LlmCore-Tools'
}

{ #category : #'llm-generated' }
GtLRefactoringToolForClassReferences >> description [
	^ 'Search the image for the references to the given class'
]

{ #category : #'llm-generated' }
GtLRefactoringToolForClassReferences >> model [
	^ model
]

{ #category : #'llm-generated' }
GtLRefactoringToolForClassReferences >> model: aModel [
	model := aModel
]

{ #category : #'llm-generated' }
GtLRefactoringToolForClassReferences >> name [
	^ 'rbClassReferences'
]

{ #category : #'llm-generated' }
GtLRefactoringToolForClassReferences >> parameters [
	^ #('className')
]

{ #category : #'llm-generated' }
GtLRefactoringToolForClassReferences >> privatePerformToolCall: aToolCall [
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
