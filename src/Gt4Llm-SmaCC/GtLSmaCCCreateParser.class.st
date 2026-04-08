Class {
	#name : #GtLSmaCCCreateParser,
	#superclass : #Object,
	#instVars : [
		'scannerClass',
		'parserClass',
		'package',
		'definition'
	],
	#category : 'Gt4Llm-SmaCC-Domain Objects'
}

{ #category : #executing }
GtLSmaCCCreateParser >> createGrammar [
	^ (GtSmaCCGrammar forDefinition: self definition)
		package: package;
		parserClassName: self parserClass;
		scannerClassName: self scannerClass;
		yourself
]

{ #category : #accessing }
GtLSmaCCCreateParser >> definition [
	^ definition
]

{ #category : #accessing }
GtLSmaCCCreateParser >> definition: anObject [
	definition := anObject
]

{ #category : #accessing }
GtLSmaCCCreateParser >> definitionDescription [
	<magritteDescription>
	^ MAStringDescription new
		label: 'Definition';
		accessor: #definition;
		beRequired
]

{ #category : #accessing }
GtLSmaCCCreateParser >> package [
	^ package
]

{ #category : #accessing }
GtLSmaCCCreateParser >> package: anObject [
	package := anObject
]

{ #category : #accessing }
GtLSmaCCCreateParser >> packageDescription [
	<magritteDescription>
	^ MAStringDescription new
		label: 'Package';
		accessor: #package;
		beRequired
]

{ #category : #accessing }
GtLSmaCCCreateParser >> parserClass [
	^ parserClass
]

{ #category : #accessing }
GtLSmaCCCreateParser >> parserClass: anObject [
	parserClass := anObject
]

{ #category : #accessing }
GtLSmaCCCreateParser >> parserClassDescription [
	<magritteDescription>
	^ MAStringDescription new
		label: 'SmaCC Parser Class';
		accessor: #parserClass;
		beRequired
]

{ #category : #accessing }
GtLSmaCCCreateParser >> scannerClass [
	^ scannerClass
]

{ #category : #accessing }
GtLSmaCCCreateParser >> scannerClass: anObject [
	scannerClass := anObject
]

{ #category : #accessing }
GtLSmaCCCreateParser >> scannerClassDescription [
	<magritteDescription>
	^ MAStringDescription new
		label: 'SmaCC Scanner Class';
		accessor: #scannerClass;
		beRequired
]

{ #category : #validation }
GtLSmaCCCreateParser >> validateOnError: aBlock [
	#(parserClass scannerClass package definition)
		do: [ :each | 
			(self perform: each) isEmptyOrNil
				ifTrue: [ ^ aBlock
						value: (GtLMissingArgumentDomainObject new
								arguments: nil;
								missingArgument: each) ] ].
	#(parserClass scannerClass)
		do: [ :each | 
			| name |
			name := self perform: each.
			((RBScanner isVariable: name) and: [ name first isUppercase ])
				ifFalse: [ ^ aBlock
						value: (GtLProblemDomainObject new description: each , ' is not a valid class name') ] ].
	[ SmaCCDefinitionParser
		parseStream: (SmaCCLineNumberStream on: self definition readStream) ]
		on: Error
		do: [ :ex | 
			^ aBlock
				value: (GtLProblemDomainObject new
						description: 'Invalid syntax in definition string near line: '
								, ex parser lineNumber printString , ', column: '
								, ex parser columnNumber printString) ]
]
