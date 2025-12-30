Class {
	#name : #GtLRefactoringToolForMethodImplementors,
	#superclass : #GtLAbstractFunctionTool,
	#instVars : [
		'model'
	],
	#category : #'Gt4LlmCore-Tools'
}

{ #category : #'llm-generated' }
GtLRefactoringToolForMethodImplementors >> description [
	^ 'Gets a method by name and returns a list of methods that implement it.'
]

{ #category : #'llm-generated' }
GtLRefactoringToolForMethodImplementors >> model [
	^ model
]

{ #category : #'llm-generated' }
GtLRefactoringToolForMethodImplementors >> model: aModel [
	model := aModel
]

{ #category : #'llm-generated' }
GtLRefactoringToolForMethodImplementors >> name [
	^ 'rbMethodImplementors'
]

{ #category : #'llm-generated' }
GtLRefactoringToolForMethodImplementors >> parameters [
	^ #('methodName')
]

{ #category : #'llm-generated' }
GtLRefactoringToolForMethodImplementors >> privatePerformToolCall: aToolCall [
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
