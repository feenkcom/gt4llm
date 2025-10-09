Class {
	#name : #GtLlmToolForSearchFilter,
	#superclass : #GtLlmAbstractFunctionTool,
	#category : #'Gt4Llm-GToolkit'
}

{ #category : #accessing }
GtLlmToolForSearchFilter class >> leJsonV4Name [
	^ #gtLlmToolForSearchFilter
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
	(arguments includesKey: 'query')
		ifFalse: [ ^ 'Query not provided' ].
	query := (arguments at: 'query') asString.
	^ [ Character cr join: ((OpalCompiler new
		source: query;
		evaluate) contents collect: [ :each | each printString ]) ]
		on: Error
		do: [ :error | 'There was an error when evaluating the query: ' , error printString ]
]
