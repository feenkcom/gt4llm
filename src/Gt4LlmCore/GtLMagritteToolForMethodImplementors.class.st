"
Magritte-based tool for retrieving method implementors.
"
Class {
	#name : #GtLMagritteToolForMethodImplementors,
	#superclass : #GtLAbstractMagritteFunctionTool,
	#category : #Gt4LlmCore
}

{ #category : #accessing }
GtLMagritteToolForMethodImplementors >> description [
	^ 'Gets a method by name and returns a list of methods that implement it.

Arguments:
- methodName: string

Return values:
- methods: array of method references
- mayHaveMore: boolean indicating if there are more matches than returned

Example JSON arguments:
{
  "methodName": "performToolCall:"
}

Example JSON response:
{
  "methods": [
    {
      "methodClassName": "GtLAbstractFunctionTool",
      "methodName": "performToolCall:",
      "classSide": false
    }
  ],
  "mayHaveMore": false
}'
]

{ #category : #accessing }
GtLMagritteToolForMethodImplementors >> methodNameDescription [
	<magritteDescription>

	^ MAStringDescription new
		label: 'Method name';
		accessor: #methodName;
		beRequired
]

{ #category : #accessing }
GtLMagritteToolForMethodImplementors >> name [
	^ 'getImplementors'
]

{ #category : #private }
GtLMagritteToolForMethodImplementors >> privatePerformToolCall: aToolCall inContext: anExecutionContext [
	| arguments methodName selector implementors |
	arguments := aToolCall arguments ifNil: [ Dictionary new ].
	methodName := arguments
		at: 'methodName'
		ifAbsent: [ ^ GtLMissingArgumentDomainObject new
				arguments: arguments;
				missingArgument: 'methodName' ].

	(methodName isNil or: [ methodName trimBoth isEmpty ])
		ifTrue: [ ^ GtLMissingArgumentDomainObject new
				arguments: arguments;
				missingArgument: 'methodName' ].

	selector := methodName asSymbol.
	implementors := (selector gtImplementors result toArray
		await: GtLSettings futureExecutionConfiguration) wait.

	^ GtLMethodReferences fromReferences: implementors
]
