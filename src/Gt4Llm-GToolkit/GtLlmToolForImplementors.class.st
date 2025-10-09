Class {
	#name : #GtLlmToolForImplementors,
	#superclass : #GtLlmAbstractFunctionTool,
	#category : #'Gt4Llm-GToolkit'
}

{ #category : #accessing }
GtLlmToolForImplementors class >> leJsonV4Name [
	^ #gtLlmToolForImplementors
]

{ #category : #accessing }
GtLlmToolForImplementors >> acceptVisitor: aVisitor [
	^ aVisitor visitGtLlmToolForImplementors: self
]

{ #category : #accessing }
GtLlmToolForImplementors >> description [
	^ 'Gets a method by name and returns a list of methods that implement it.'
]

{ #category : #accessing }
GtLlmToolForImplementors >> name [
	^ 'getImplementors'
]

{ #category : #accessing }
GtLlmToolForImplementors >> parameters [
	^ #('methodName')
]

{ #category : #accessing }
GtLlmToolForImplementors >> privatePerformToolCall: aToolCall [
	| argument methodName implementors |
	argument := aToolCall anyArgument.
	argument ifNil: [ ^ 'Method name not provided' ].
	methodName := argument asSymbol.
	implementors := methodName gtImplementors result toArray wait collect: #name.
	implementors isEmpty ifTrue: [ ^ 'No implementors found' ].
	^ Character cr join: implementors
]
