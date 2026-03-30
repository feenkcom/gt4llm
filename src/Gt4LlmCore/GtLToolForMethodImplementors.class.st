Class {
	#name : #GtLToolForMethodImplementors,
	#superclass : #GtLAbstractPlainSchemaFunctionTool,
	#category : #'Gt4LlmCore-Tools'
}

{ #category : #testing }
GtLToolForMethodImplementors class >> isDeprecated [
	^ true
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
GtLToolForMethodImplementors >> parametersDescription [
	^ #('methodName')
]

{ #category : #accessing }
GtLToolForMethodImplementors >> privatePerformToolCall: aToolCall inContext: anExecutionContext [
	| arguments argument methodName implementors promise |
	arguments := aToolCall arguments ifNil: [ Dictionary new ].
	argument := aToolCall anyArgument.
	argument
		ifNil: [ ^ GtLMissingArgumentDomainObject new
				arguments: arguments;
				missingArgument: 'methodName' ].
	methodName := argument asSymbol.
	promise := methodName gtImplementors result toArray
			await: GtLSettings futureExecutionConfiguration.
	implementors := promise wait.
	^ GtLMethodsDomainObject new 
		methods: (implementors first: (100 min: implementors size))
]
