Class {
	#name : #GtLToolForMethodReferences,
	#superclass : #GtLAbstractPlainSchemaFunctionTool,
	#category : 'Gt4LlmCore-Tools'
}

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
GtLToolForMethodReferences >> parametersDescription [
	^ #('selector')
]

{ #category : #accessing }
GtLToolForMethodReferences >> privatePerformToolCall: aToolCall [
	| arguments argument selector references promise |
	arguments := aToolCall arguments ifNil: [ Dictionary new ].
	argument := aToolCall anyArgument.
	argument
		ifNil: [ ^ GtLMissingArgumentDomainObject new
				receiverName: self name;
				arguments: arguments;
				missingArgument: 'methodName' ].
	selector := argument asSymbol.
	promise := selector gtReferences result toArray
			await: GtLSettings futureExecutionConfiguration.
	references := promise wait.
	^ GtLMethodsDomainObject new
		methods: (references first: (100 min: references size));
		mayHaveMore: references size > 100
]
