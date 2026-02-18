Class {
	#name : #GtLMagritteToolForMethodsSource,
	#superclass : #GtLAbstractMagritteFunctionTool,
	#category : #'Gt4LlmCore-Tools'
}

{ #category : #visiting }
GtLMagritteToolForMethodsSource >> acceptVisitor: aVisitor [
	^ aVisitor visitGtLlmToolForMethodsSource: self
]

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
	arguments := aToolCall arguments 
		ifNil: [ Dictionary new ].
	methodDescriptors := arguments
			at: 'methodDescriptors' ifAbsent: [ 
				^ GtLMissingArgumentDomainObject new
					arguments: arguments;
					missingArgument: 'methodDescriptors' ].
	
	methodObjects := OrderedCollection new: methodDescriptors size.
	methodDescriptors do: [ :aMethodDescriptor | 
		| result |
		result := aMethodDescriptor 
			methodObjectIfMissing: [ :anErrorResult | anErrorResult ].
		methodObjects add: result ].
					
	^ GtLMethodsWithSource new 
			methods: methodObjects asArray
]
