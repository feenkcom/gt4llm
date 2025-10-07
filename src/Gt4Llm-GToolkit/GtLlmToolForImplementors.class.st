Class {
	#name : #GtLlmToolForImplementors,
	#superclass : #GtLlmAbstractFunctionTool,
	#category : #'Gt4Llm-GToolkit'
}

{ #category : #'llm-generated' }
GtLlmToolForImplementors >> acceptVisitor: aVisitor [
	^ aVisitor visitGtLlmToolForImplementors: self
]

{ #category : #'llm-generated' }
GtLlmToolForImplementors >> description [
	^ 'Gets a method by name and returns a list of methods that implement it.'
]

{ #category : #'llm-generated' }
GtLlmToolForImplementors >> name [
	^ 'getImplementors'
]

{ #category : #'llm-generated' }
GtLlmToolForImplementors >> parameters [
	^ #('methodName')
]

{ #category : #'llm-generated' }
GtLlmToolForImplementors >> privatePerformToolCall: aToolCall [
	| argument methodName implementors |
	argument := aToolCall anyArgument.
	argument ifNil: [ ^ 'Method name not provided' ].
	methodName := argument asSymbol.
	implementors := methodName gtImplementors result toArray wait collect: #name.
	implementors isEmpty ifTrue: [ ^ 'No implementors found' ].
	^ Character cr join: implementors
]
