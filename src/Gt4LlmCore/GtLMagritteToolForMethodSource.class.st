Class {
	#name : #GtLMagritteToolForMethodSource,
	#superclass : #GtLAbstractMagritteFunctionTool,
	#category : 'Gt4LlmCore-Tools'
}

{ #category : #accessing }
GtLMagritteToolForMethodSource >> description [
	^ 'Gets source code for a method. Arguments must provide a methodDescriptor object with methodClassName, methodName, and classSide values.

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
