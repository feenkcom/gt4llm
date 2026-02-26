Class {
	#name : #GtLMagritteToolForMethodsSource,
	#superclass : #GtLAbstractMagritteFunctionTool,
	#category : 'Gt4LlmCore-Tools'
}

{ #category : #accessing }
GtLMagritteToolForMethodsSource >> description [
	^ 'Gets source code for multiple methods. Arguments must provide a methods array of method descriptors with className, methodName, and optional classSide values.

Example JSON arguments:
{
  "methods": [
    {"className": "Collection", "methodName": "withAll:", "classSide": true},
    {"className": "GtLToolForMethodImplementors", "methodName": "privatePerformToolCall:", "classSide": false}
  ]
}

Example JSON response:
{
  "methods": [
    {"methodClass": "Collection class", "selector": "withAll:", "method": "Collection class>>#withAll:", "sourceCode": "..."},
    {"methodClass": "GtLToolForMethodImplementors", "selector": "privatePerformToolCall:", "method": "GtLToolForMethodImplementors>>#privatePerformToolCall:", "sourceCode": "..."}
  ]
}'
]

{ #category : #descriptions }
GtLMagritteToolForMethodsSource >> methodDescriptors [
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
GtLMagritteToolForMethodsSource >> privatePerformToolCall: aToolCall [
	| arguments methodDescriptors methodObjects |
	arguments := aToolCall arguments ifNil: [ Dictionary new ].
	methodDescriptors := arguments
			at: 'methodDescriptors'
			ifAbsent: [ ^ GtLMissingArgumentDomainObject new
					arguments: arguments;
					missingArgument: 'methodDescriptors' ].
	methodObjects := methodDescriptors
			collect: [ :aMethodDescriptor | 
				aMethodDescriptor methodObjectIfMissing: [ :anErrorResult | anErrorResult ] ].
	^ GtLMethodsWithSource new methods: methodObjects asArray
]
