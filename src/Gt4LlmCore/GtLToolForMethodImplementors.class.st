Class {
	#name : #GtLToolForMethodImplementors,
	#superclass : #GtLAbstractFunctionTool,
	#category : 'Gt4LlmCore-Tools'
}

{ #category : #accessing }
GtLToolForMethodImplementors class >> leJsonV4Name [
	^ #gtLToolForMethodImplementors
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
	| arguments argument methodName implementors promise |
	arguments := aToolCall arguments ifNil: [ Dictionary new ].
	argument := aToolCall anyArgument.
	argument
		ifNil: [ ^ GtLMissingArgumentDomainObject new
				receiverName: self name;
				arguments: arguments;
				missingArgument: 'methodName' ].
	methodName := argument asSymbol.
	promise := methodName gtImplementors result toArray
			await: GtLSettings futureExecutionConfiguration.
	implementors := promise wait.
	^ GtLMethodsDomainObject new 
		methods: (implementors first: (100 min: implementors size))
]
