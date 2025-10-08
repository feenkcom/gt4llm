Class {
	#name : #GtLlmToolForMethodReferences,
	#superclass : #GtLlmAbstractFunctionTool,
	#category : #'Gt4Llm-GToolkit'
}

{ #category : #'as yet unclassified' }
GtLlmToolForMethodReferences class >> leJsonV4Name [
	^ #gtLlmToolForMethodReferences
]

{ #category : #'llm-generated' }
GtLlmToolForMethodReferences >> acceptVisitor: aVisitor [
	^ aVisitor visitGtLlmToolForMethodReferences: self
]

{ #category : #'llm-generated' }
GtLlmToolForMethodReferences >> description [
	^ 'Search the image for the senders of the given selector (maximum 100)'
]

{ #category : #'llm-generated' }
GtLlmToolForMethodReferences >> name [
	^ 'methodReferences'
]

{ #category : #'llm-generated' }
GtLlmToolForMethodReferences >> parameters [
	^ #('selector')
]

{ #category : #'llm-generated' }
GtLlmToolForMethodReferences >> privatePerformToolCall: aToolCall [
	| argument selector references |
	argument := aToolCall anyArgument.
	argument ifNil: [ ^ 'Selector not provided' ].
	selector := argument asSymbol.
	references := selector gtReferences result toArray wait collect: #name.
	references isEmpty ifTrue: [ ^ 'No references found' ].
	^ Character cr join: (references first: (100 min: references size))
]
