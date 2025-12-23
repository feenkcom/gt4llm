Class {
	#name : #GtLlmRefactoringToolForMethodImplementors,
	#superclass : #GtLlmAbstractFunctionTool,
	#instVars : [
		'model'
	],
	#category : #'Gt4Llm-Refactoring'
}

{ #category : #'llm-generated' }
GtLlmRefactoringToolForMethodImplementors >> description [
	^ 'Gets a method by name and returns a list of methods that implement it.'
]

{ #category : #'llm-generated' }
GtLlmRefactoringToolForMethodImplementors >> model [
	^ model
]

{ #category : #'llm-generated' }
GtLlmRefactoringToolForMethodImplementors >> model: aModel [
	model := aModel
]

{ #category : #'llm-generated' }
GtLlmRefactoringToolForMethodImplementors >> name [
	^ 'rbMethodImplementors'
]

{ #category : #'llm-generated' }
GtLlmRefactoringToolForMethodImplementors >> parameters [
	^ #('methodName')
]

{ #category : #'llm-generated' }
GtLlmRefactoringToolForMethodImplementors >> privatePerformToolCall: aToolCall [
	| arguments methodName result |
	self model ifNil: [ ^ 'Model not provided' ].
	arguments := aToolCall arguments ifNil: [ Dictionary new ].
	methodName := arguments at: 'methodName' ifAbsent: [ ^ 'Method name not provided' ].
	result := String
		streamContents: [ :stream |
			self model
				allImplementorsOf: methodName asSymbol
				do: [ :each |
					stream << each name.
					each isMeta ifTrue: [ stream << ' class' ].
					stream cr ] ].
	^ result isEmpty
		ifTrue: [ 'No implementors found' ]
		ifFalse: [ result ]
]
