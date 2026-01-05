Class {
	#name : #GtLToolForSearchFilter,
	#superclass : #GtLAbstractFunctionTool,
	#category : #'Gt4LlmCore-Tools'
}

{ #category : #accessing }
GtLToolForSearchFilter class >> leJsonV4Name [
	^ #gtLToolForSearchFilter
]

{ #category : #accessing }
GtLToolForSearchFilter class >> maximumResultItemCount [
	^ 100
]

{ #category : #accessing }
GtLToolForSearchFilter >> acceptVisitor: aVisitor [
	^ aVisitor visitGtLlmToolForSearchFilter: self
]

{ #category : #accessing }
GtLToolForSearchFilter >> description [
	^ 'Use GT filters to find methods'
]

{ #category : #accessing }
GtLToolForSearchFilter >> name [
	^ 'gtSearchFilter'
]

{ #category : #accessing }
GtLToolForSearchFilter >> parameters [
	^ #('query')
]

{ #category : #accessing }
GtLToolForSearchFilter >> privatePerformToolCall: aToolCall [
	| arguments query |
	arguments := aToolCall arguments ifNil: [ Dictionary new ].
	(arguments includesKey: 'query') ifFalse: [ ^ 'Query not provided' ].
	query := (arguments at: 'query') asString.
	^ [ | result resultItems |
	result := OpalCompiler new
			source: query;
			evaluate.
	resultItems := result contents.
	resultItems := resultItems
			first: (self class maximumResultItemCount min: resultItems size).
	Character cr join: (resultItems collect: [ :each | each printString ]) ]
		on: Error
		do: [ :error | 'There was an error when evaluating the query: ' , error printString ]
]
