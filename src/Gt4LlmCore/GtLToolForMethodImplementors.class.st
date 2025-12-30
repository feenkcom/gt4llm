Class {
	#name : #GtLToolForMethodImplementors,
	#superclass : #GtLAbstractFunctionTool,
	#category : #'Gt4LlmCore-Tools'
}

{ #category : #accessing }
GtLToolForMethodImplementors class >> leJsonV4Name [
	^ #gtLlmToolForMethodImplementors
]

{ #category : #accessing }
GtLToolForMethodImplementors >> acceptVisitor: aVisitor [
	^ aVisitor visitGtLlmToolForImplementors: self
]

{ #category : #accessing }
GtLToolForMethodImplementors >> description [
	^ 'Gets a method by name and returns a list of methods that implement it.'
]

{ #category : #accessing }
GtLToolForMethodImplementors >> name [
	^ 'getImplementors'
]

{ #category : #accessing }
GtLToolForMethodImplementors >> parameters [
	^ #('methodName')
]

{ #category : #accessing }
GtLToolForMethodImplementors >> privatePerformToolCall: aToolCall [
	| argument methodName implementors |
	argument := aToolCall anyArgument.
	argument ifNil: [ ^ 'Method name not provided' ].
	methodName := argument asSymbol.
	implementors := methodName gtImplementors result toArray wait collect: #name.
	implementors isEmpty ifTrue: [ ^ 'No implementors found' ].
	^ Character cr join: implementors
]
