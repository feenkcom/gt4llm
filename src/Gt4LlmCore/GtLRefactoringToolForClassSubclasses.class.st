Class {
	#name : #GtLRefactoringToolForClassSubclasses,
	#superclass : #GtLAbstractFunctionTool,
	#instVars : [
		'model'
	],
	#category : #'Gt4LlmCore-Tools'
}

{ #category : #'as yet unclassified' }
GtLRefactoringToolForClassSubclasses class >> leJsonV4Name [
	^ #gtLRefactoringToolForClassSubclasses
]

{ #category : #'llm-generated' }
GtLRefactoringToolForClassSubclasses >> description [
	^ 'Retrieve all subclasses of the given class'
]

{ #category : #'llm-generated' }
GtLRefactoringToolForClassSubclasses >> model [
	^ model
]

{ #category : #'llm-generated' }
GtLRefactoringToolForClassSubclasses >> model: aModel [
	model := aModel
]

{ #category : #'llm-generated' }
GtLRefactoringToolForClassSubclasses >> name [
	^ 'rbClassSubclasses'
]

{ #category : #'llm-generated' }
GtLRefactoringToolForClassSubclasses >> parameters [
	^ #('className')
]

{ #category : #'llm-generated' }
GtLRefactoringToolForClassSubclasses >> privatePerformToolCall: aToolCall [
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
