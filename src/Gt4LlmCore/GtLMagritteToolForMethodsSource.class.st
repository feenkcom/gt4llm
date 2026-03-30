Class {
	#name : #GtLMagritteToolForMethodsSource,
	#superclass : #GtLAbstractMagritteFunctionTool,
	#category : 'Gt4LlmCore-Tools'
}

{ #category : #accessing }
GtLMagritteToolForMethodsSource >> description [
	^ 'Gets source code for multiple methods. Arguments must provide a methodDescriptors array of method descriptors with methodClassName, methodName, and optional classSide values.

Example JSON arguments:
{
  "methodDescriptors": [
    {"methodClassName": "Collection", "methodName": "withAll:", "classSide": true},
    {"methodClassName": "GtLToolForMethodImplementors", "methodName": "privatePerformToolCall:", "classSide": false}
  ]
}

Example JSON response:
{
  "methods": [
    {"methodReference": {"methodName": "withAll:", "methodClassName": "Collection", "classSide": true}, "sourceCode": "..."},
    {"methodReference": {"methodName": "privatePerformToolCall:", "methodClassName": "GtLToolForMethodImplementors", "classSide": false}, "sourceCode": "..."}
  ]
}'
]

{ #category : #descriptions }
GtLMagritteToolForMethodsSource >> methodDescriptorsDescription [
	<magritteDescription>
	
	 ^ MAToManyRelationDescription new
			accessor: #methodDescriptors;
			classes: {GtLMethodReference};
			beRequired
]

{ #category : #accessing }
GtLMagritteToolForMethodsSource >> name [
	^ 'getCodeOfMethods'
]

{ #category : #execution }
GtLMagritteToolForMethodsSource >> privatePerformToolCall: aToolCall inContext: anExecutionContext [
	| arguments methodDescriptors methodObjects |
	arguments := aToolCall arguments ifNil: [ Dictionary new ].
	methodDescriptors := arguments	at: 'methodDescriptors'.
	methodObjects := methodDescriptors
			collect: [ :aMethodDescriptor | 
				aMethodDescriptor methodObjectIfMissing: [ :anErrorResult | anErrorResult ] ].
	^ GtLMethodsWithSource new 
			methods: methodObjects asArray
]
