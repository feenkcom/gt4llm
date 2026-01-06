Class {
	#name : #GtLToolForMethodReferences,
	#superclass : #GtLAbstractFunctionTool,
	#category : #'Gt4LlmCore-Tools'
}

{ #category : #accessing }
GtLToolForMethodReferences class >> leJsonV4Name [
	^ #gtLToolForMethodReferences
]

{ #category : #accessing }
GtLToolForMethodReferences >> acceptVisitor: aVisitor [
	^ aVisitor visitGtLlmToolForMethodReferences: self
]

{ #category : #accessing }
GtLToolForMethodReferences >> description [
	^ 'Search the image for the senders of the given selector (maximum 100)'
]

{ #category : #accessing }
GtLToolForMethodReferences >> name [
	^ 'methodReferences'
]

{ #category : #accessing }
GtLToolForMethodReferences >> parameters [
	^ #('selector')
]

{ #category : #accessing }
GtLToolForMethodReferences >> privatePerformToolCall: aToolCall [
	| argument selector references |
	argument := aToolCall anyArgument.
	argument ifNil: [ ^ 'Selector not provided' ].
	selector := argument asSymbol.
	references := selector gtReferences result toArray wait collect: #name.
	references isEmpty ifTrue: [ ^ 'No references found' ].
	^ Character cr join: (references first: (100 min: references size))
]
