Class {
	#name : #GtLlmToolForSearchFilter,
	#superclass : #GtLlmAbstractFunctionTool,
	#category : 'Gt4Llm-GToolkit-Tools'
}

{ #category : #accessing }
GtLlmToolForSearchFilter class >> leJsonV4Name [
	^ #gtLlmToolForSearchFilter
]

{ #category : #accessing }
GtLlmToolForSearchFilter class >> maximumResultItemCount [
	^ 100
]

{ #category : #accessing }
GtLlmToolForSearchFilter >> acceptVisitor: aVisitor [
	^ aVisitor visitGtLlmToolForSearchFilter: self
]

{ #category : #accessing }
GtLlmToolForSearchFilter >> description [
	^ 'Use GT filters to find methods'
]

{ #category : #accessing }
GtLlmToolForSearchFilter >> name [
	^ 'gtSearchFilter'
]

{ #category : #accessing }
GtLlmToolForSearchFilter >> parameters [
	^ #('query')
]

{ #category : #accessing }
GtLlmToolForSearchFilter >> privatePerformToolCall: aToolCall [
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
