Class {
	#name : #GtLlmRefactoringToolForClassLookup,
	#superclass : #GtLlmAbstractFunctionTool,
	#instVars : [
		'model'
	],
	#category : #'Gt4Llm-Refactoring'
}

{ #category : #'llm-generated' }
GtLlmRefactoringToolForClassLookup >> description [
	^ 'Get the details of a class as JSON.'
]

{ #category : #'llm-generated' }
GtLlmRefactoringToolForClassLookup >> model [
	^ model
]

{ #category : #'llm-generated' }
GtLlmRefactoringToolForClassLookup >> model: aModel [
	model := aModel
]

{ #category : #'llm-generated' }
GtLlmRefactoringToolForClassLookup >> name [
	^ 'rbLookupClass'
]

{ #category : #'llm-generated' }
GtLlmRefactoringToolForClassLookup >> parameters [
	^ #('className')
]

{ #category : #'llm-generated' }
GtLlmRefactoringToolForClassLookup >> privatePerformToolCall: aToolCall [
	| arguments className targetClass |
	self model ifNil: [ ^ 'Model not provided' ].
	arguments := aToolCall arguments ifNil: [ Dictionary new ].
	className := arguments at: 'className' ifAbsent: [ ^ 'Class name not provided' ].
	targetClass := self model classNamed: className.
	targetClass ifNil: [ ^ 'Class not found' ].
	^ STONJSON
		toString: {
			'class' -> targetClass name asString.
			'superclass' -> (targetClass superclass
				ifNil: [ nil ]
				ifNotNil: [ :spr | spr name asString ]).
			'package' -> targetClass realClass packageName.
			'instanceSlots' -> targetClass instanceVariableNames asArray.
			'classSlots' -> targetClass classSide instanceVariableNames asArray.
			'allInstanceMethods' -> targetClass selectors asArray.
			'allClassMethods' -> targetClass classSide selectors asArray } asDictionary
]
