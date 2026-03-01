Class {
	#name : #GtLSmaCCParserTest,
	#superclass : #Object,
	#instVars : [
		'parserClass',
		'example',
		'startingState'
	],
	#category : #'Gt4Llm-SmaCC-Domain Objects'
}

{ #category : #accessing }
GtLSmaCCParserTest >> example [
	^ example
]

{ #category : #accessing }
GtLSmaCCParserTest >> example: anObject [
	example := anObject
]

{ #category : #accessing }
GtLSmaCCParserTest >> exampleDescription [
	<magritteDescription>
	^ MAStringDescription new
		label: 'Example';
		accessor: #example;
		beRequired
]

{ #category : #accessing }
GtLSmaCCParserTest >> parserClass [
	^ parserClass
]

{ #category : #accessing }
GtLSmaCCParserTest >> parserClass: anObject [
	parserClass := anObject
]

{ #category : #accessing }
GtLSmaCCParserTest >> parserClassDescription [
	<magritteDescription>
	^ MAStringDescription new
		label: 'Parser Class';
		accessor: #parserClass;
		beRequired
]

{ #category : #accessing }
GtLSmaCCParserTest >> startingState [
	^ startingState
]

{ #category : #accessing }
GtLSmaCCParserTest >> startingState: anObject [
	startingState := anObject
]

{ #category : #accessing }
GtLSmaCCParserTest >> startingStateDescription [
	<magritteDescription>
	^ MAStringDescription new
		label: 'Starting State';
		accessor: #startingState;
		beOptional
]

{ #category : #accessing }
GtLSmaCCParserTest >> testParse [
	| selector parser startingStateId |
	self parserClass isEmptyOrNil
		ifTrue: [ ^ GtLMissingArgumentDomainObject new
				arguments: nil;
				missingArgument: #parserClass ].
	self example
		ifNil: [ ^ GtLMissingArgumentDomainObject new
				arguments: nil;
				missingArgument: #example ].
	parser := Smalltalk globals at: self parserClass asSymbol ifAbsent: [ Object ].
	(parser inheritsFrom: SmaCCParser)
		ifFalse: [ ^ GtLProblemDomainObject new
				description: self parserClass , ' is not a valid SmaCC parser' ].

	(self startingState isEmptyOrNil not
		and: [ self startingState allSatisfy: #isDigit ])
		ifTrue: [ startingStateId := self startingState asInteger ]
		ifFalse: [ selector := self startingState isEmptyOrNil
					ifTrue: [ #defaultStartingState ]
					ifFalse: [ ('startingStateFor' , self startingState) asSymbol ].
			(parser respondsTo: selector)
				ifFalse: [ ^ GtLProblemDomainObject new
						description: self startingState , ' is not a valid starting state for the parser' ].
			startingStateId := parser perform: selector ].

	^ [ parser
		parseStream: (SmaCCLineNumberStream on: self example readStream)
		startingAt: startingStateId.
	GtLSmaCCSuccess new message: 'The sample was successfully parsed' ]
		on: SmaCCParserError
		do: [ :ex | 
			ex
				return: (GtLProblemDomainObject new
						description: 'An error occurred during parsing near line: '
								, ex parser lineNumber printString , ', column: '
								, ex parser columnNumber printString) ]
]
