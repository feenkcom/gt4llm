Class {
	#name : #GtLRefactoringToolForMethodReferences,
	#superclass : #GtLAbstractFunctionTool,
	#instVars : [
		'model'
	],
	#category : #'Gt4LlmCore-Tools'
}

{ #category : #'llm-generated' }
GtLRefactoringToolForMethodReferences >> description [
	^ 'Search the image for the senders of the given selector (maximum 100)'
]

{ #category : #'llm-generated' }
GtLRefactoringToolForMethodReferences >> model [
	^ model
]

{ #category : #'llm-generated' }
GtLRefactoringToolForMethodReferences >> model: aModel [
	model := aModel
]

{ #category : #'llm-generated' }
GtLRefactoringToolForMethodReferences >> name [
	^ 'rbMethodReferences'
]

{ #category : #'llm-generated' }
GtLRefactoringToolForMethodReferences >> parameters [
	^ #('selector')
]

{ #category : #'llm-generated' }
GtLRefactoringToolForMethodReferences >> privatePerformToolCall: aToolCall [
	| arguments selector |
	self model ifNil: [ ^ 'Model not provided' ].
	arguments := aToolCall arguments ifNil: [ Dictionary new ].
	selector := arguments at: 'selector' ifAbsent: [ ^ 'Selector not provided' ].
	^ self sendersOf: selector
]

{ #category : #'llm-generated' }
GtLRefactoringToolForMethodReferences >> sendersOf: selectorString [
	| stream count |
	stream := WriteStream on: String new.
	count := 0.
	self model
		allReferencesTo: selectorString asSymbol
		do: [ :each |
			stream << each modelClass name.
			each modelClass isMeta ifTrue: [ stream << ' class' ].
			stream << '>>#' << each selector << String cr.
			count := count + 1.
			count = 100 ifTrue: [ ^ stream contents ] ].
	count = 0 ifTrue: [ ^ 'No references found' ].
	^ stream contents
]
