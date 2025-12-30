Class {
	#name : #GtLRefactoringToolForMethodSource,
	#superclass : #GtLAbstractFunctionTool,
	#instVars : [
		'model'
	],
	#category : #'Gt4LlmCore-Tools'
}

{ #category : #'llm-generated' }
GtLRefactoringToolForMethodSource >> description [
	^ 'Gets a method by name and returns its source code. The third argument (classSide) should be true if the method is on the class side. It should be false if the method if on the instance side.'
]

{ #category : #'llm-generated' }
GtLRefactoringToolForMethodSource >> model [
	^ model
]

{ #category : #'llm-generated' }
GtLRefactoringToolForMethodSource >> model: aModel [
	model := aModel
]

{ #category : #'llm-generated' }
GtLRefactoringToolForMethodSource >> name [
	^ 'rbMethodSource'
]

{ #category : #'llm-generated' }
GtLRefactoringToolForMethodSource >> parameters [
	^ #('className' 'methodName' 'classSide')
]

{ #category : #'llm-generated' }
GtLRefactoringToolForMethodSource >> privatePerformToolCall: aToolCall [
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
