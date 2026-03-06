"
Magritte-based tool for retrieving method references.
"
Class {
	#name : #GtLMagritteToolForMethodReferences,
	#superclass : #GtLAbstractMagritteFunctionTool,
	#category : #'Gt4LlmCore-Tools'
}

{ #category : #accessing }
GtLMagritteToolForMethodReferences >> description [
	^ 'Search the image for the senders of the given selector.

Arguments:
- methodName: string

Return values:
- methods: array of method references
- mayHaveMore: boolean indicating if there are more matches than returned

Example JSON arguments:
{
  "methodName": "value"
}

Example JSON response:
{
  "methods": [
    {
      "methodClassName": "Object",
      "methodName": "value",
      "classSide": false
    }
  ],
  "mayHaveMore": false
}'
]

{ #category : #accessing }
GtLMagritteToolForMethodReferences >> methodNameDescription [
	<magritteDescription>

	^ MAStringDescription new
		label: 'Method name';
		accessor: #methodName;
		beRequired
]

{ #category : #accessing }
GtLMagritteToolForMethodReferences >> name [
	^ 'methodReferences'
]

{ #category : #private }
GtLMagritteToolForMethodReferences >> privatePerformToolCall: aToolCall inContext: anExecutionContext [
	| arguments methodName selector references |
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
	references := (selector gtReferences result toArray
		await: GtLSettings futureExecutionConfiguration) wait.

	^ GtLMethodReferences fromReferences: references
]
