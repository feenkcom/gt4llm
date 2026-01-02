Class {
	#name : #GtLlmRefactoringToolForClassSubclasses,
	#superclass : #GtLlmAbstractFunctionTool,
	#instVars : [
		'model'
	],
	#category : #'Gt4Llm-Refactoring'
}

{ #category : #'as yet unclassified' }
GtLlmRefactoringToolForClassSubclasses class >> leJsonV4Name [
	^ #gtLlmRefactoringToolForClassSubclasses
]

{ #category : #'llm-generated' }
GtLlmRefactoringToolForClassSubclasses >> description [
	^ 'Retrieve all subclasses of the given class'
]

{ #category : #'llm-generated' }
GtLlmRefactoringToolForClassSubclasses >> model [
	^ model
]

{ #category : #'llm-generated' }
GtLlmRefactoringToolForClassSubclasses >> model: aModel [
	model := aModel
]

{ #category : #'llm-generated' }
GtLlmRefactoringToolForClassSubclasses >> name [
	^ 'rbClassSubclasses'
]

{ #category : #'llm-generated' }
GtLlmRefactoringToolForClassSubclasses >> parameters [
	^ #('className')
]

{ #category : #'llm-generated' }
GtLlmRefactoringToolForClassSubclasses >> privatePerformToolCall: aToolCall [
	| arguments className targetClass subclassNames |
	self model ifNil: [ ^ 'Model not provided' ].
	arguments := aToolCall arguments ifNil: [ Dictionary new ].
	className := arguments
		at: 'className'
		ifAbsent: [ ^ 'Class name not provided' ].
	targetClass := self model classNamed: className.
	targetClass ifNil: [ ^ 'Class not found' ].
	subclassNames := targetClass subclasses collect: [ :each | each name asString ].
	subclassNames isEmpty ifTrue: [ ^ 'No subclasses found' ].
	^ Character cr join: subclassNames
]
