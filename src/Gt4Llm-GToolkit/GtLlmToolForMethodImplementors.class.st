Class {
	#name : #GtLlmToolForMethodImplementors,
	#superclass : #GtLlmAbstractFunctionTool,
	#category : #'Gt4Llm-GToolkit'
}

{ #category : #accessing }
GtLlmToolForMethodImplementors class >> leJsonV4Name [
	^ #gtLlmToolForMethodImplementors
]

{ #category : #accessing }
GtLlmToolForMethodImplementors >> acceptVisitor: aVisitor [
	^ aVisitor visitGtLlmToolForImplementors: self
]

{ #category : #accessing }
GtLlmToolForMethodImplementors >> description [
	^ 'Gets a method by name and returns a list of methods that implement it.'
]

{ #category : #accessing }
GtLlmToolForMethodImplementors >> name [
	^ 'getImplementors'
]

{ #category : #accessing }
GtLlmToolForMethodImplementors >> parameters [
	^ #('methodName')
]

{ #category : #accessing }
GtLlmToolForMethodImplementors >> privatePerformToolCall: aToolCall [
	| argument methodName implementors |
	argument := aToolCall anyArgument.
	argument ifNil: [ ^ 'Method name not provided' ].
	methodName := argument asSymbol.
	implementors := methodName gtImplementors result toArray wait collect: #name.
	implementors isEmpty ifTrue: [ ^ 'No implementors found' ].
	^ Character cr join: implementors
]
