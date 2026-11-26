Class {
	#name : #GtLMagritteToolForMethodSource,
	#superclass : #GtLAbstractMagritteFunctionTool,
	#category : #'Gt4LlmCore-Tools'
}

{ #category : #accessing }
GtLMagritteToolForMethodSource >> description [
	^ 'Gets source code for a method. Arguments must provide a methodDescriptor object with methodClassName, methodName, and classSide values.

methodClassName may name a class or a trait; classSide true means its class side. Only a method defined by that class or trait itself is returned. For an inherited method or a copy provided by a trait, the result is an error whose definingMethodReference names the method that holds the source; ask for that method instead. For a method that a trait requires, definingMethodReference names the requirement in the trait. For a trait conflict, conflictingMethodReferences lists the conflicting methods, and conflictLocationReference, when present, names where they conflict.

Example JSON arguments:
{
  "methodDescriptor": {"methodClassName": "Collection", "methodName": "withAll:", "classSide": true}
}

Example JSON response:
{
  "methodReference": {"methodName": "withAll:", "methodClassName": "Collection", "classSide": true},
  "sourceCode": "..."
}'
]

{ #category : #descriptions }
GtLMagritteToolForMethodSource >> methodDescriptorDescription [
	<magritteDescription>
	
	^ MAToOneRelationDescription new
			accessor: #methodDescriptor;
			classes: {GtLMethodReference};
			beRequired
]

{ #category : #accessing }
GtLMagritteToolForMethodSource >> name [
	^ 'getCodeOfMethod'
]

{ #category : #execution }
GtLMagritteToolForMethodSource >> privatePerformToolCall: aToolCall inContext: anExecutionContext [
	| arguments methodDescriptor |
	arguments := aToolCall arguments ifNil: [ Dictionary new ].
	
	methodDescriptor := arguments at: 'methodDescriptor'.
	
	^ methodDescriptor 
			methodObjectIfMissing: [ :anErrorResult | anErrorResult ]
]
