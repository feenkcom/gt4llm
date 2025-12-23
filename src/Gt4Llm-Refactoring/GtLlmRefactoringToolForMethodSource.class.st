Class {
	#name : #GtLlmRefactoringToolForMethodSource,
	#superclass : #GtLlmAbstractFunctionTool,
	#instVars : [
		'model'
	],
	#category : #'Gt4Llm-Refactoring'
}

{ #category : #'llm-generated' }
GtLlmRefactoringToolForMethodSource >> description [
	^ 'Gets a method by name and returns its source code. The third argument (classSide) should be true if the method is on the class side. It should be false if the method if on the instance side.'
]

{ #category : #'llm-generated' }
GtLlmRefactoringToolForMethodSource >> model [
	^ model
]

{ #category : #'llm-generated' }
GtLlmRefactoringToolForMethodSource >> model: aModel [
	model := aModel
]

{ #category : #'llm-generated' }
GtLlmRefactoringToolForMethodSource >> name [
	^ 'rbMethodSource'
]

{ #category : #'llm-generated' }
GtLlmRefactoringToolForMethodSource >> parameters [
	^ #('className' 'methodName' 'classSide')
]

{ #category : #'llm-generated' }
GtLlmRefactoringToolForMethodSource >> privatePerformToolCall: aToolCall [
	| arguments className methodName classSideFlag targetClass searchClass method |
	self model ifNil: [ ^ 'Model not provided' ].
	arguments := aToolCall arguments ifNil: [ Dictionary new ].
	className := arguments at: 'className' ifAbsent: [ ^ 'Class name not provided' ].
	methodName := arguments at: 'methodName' ifAbsent: [ ^ 'Method name not provided' ].
	targetClass := self model classNamed: className.
	targetClass ifNil: [ ^ 'Class not found' ].
	classSideFlag := arguments at: 'classSide' ifAbsent: [ false ].
	searchClass := (#(''true'' true) includes: classSideFlag)
		ifTrue: [ targetClass classSide ]
		ifFalse: [ targetClass ].
	method := searchClass methodFor: methodName asSymbol.
	method ifNil: [ ^ 'Method not found' ].
	^ method source
]
