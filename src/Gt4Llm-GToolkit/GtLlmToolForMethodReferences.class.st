Class {
	#name : #GtLlmToolForMethodReferences,
	#superclass : #GtLlmAbstractFunctionTool,
	#category : 'Gt4Llm-GToolkit-Tools'
}

{ #category : #accessing }
GtLlmToolForMethodReferences class >> leJsonV4Name [
	^ #gtLlmToolForMethodReferences
]

{ #category : #accessing }
GtLlmToolForMethodReferences >> acceptVisitor: aVisitor [
	^ aVisitor visitGtLlmToolForMethodReferences: self
]

{ #category : #accessing }
GtLlmToolForMethodReferences >> description [
	^ 'Search the image for the senders of the given selector (maximum 100)'
]

{ #category : #accessing }
GtLlmToolForMethodReferences >> name [
	^ 'methodReferences'
]

{ #category : #accessing }
GtLlmToolForMethodReferences >> parameters [
	^ #('selector')
]

{ #category : #accessing }
GtLlmToolForMethodReferences >> privatePerformToolCall: aToolCall [
	| argument selector references |
	argument := aToolCall anyArgument.
	argument ifNil: [ ^ 'Selector not provided' ].
	selector := argument asSymbol.
	references := selector gtReferences result toArray wait collect: #name.
	references isEmpty ifTrue: [ ^ 'No references found' ].
	^ Character cr join: (references first: (100 min: references size))
]
