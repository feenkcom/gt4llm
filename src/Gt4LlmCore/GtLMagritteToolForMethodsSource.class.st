Class {
	#name : #GtLMagritteToolForMethodsSource,
	#superclass : #GtLAbstractMagritteFunctionTool,
	#category : #'Gt4LlmCore-Tools'
}

{ #category : #accessing }
GtLMagritteToolForMethodsSource >> description [
	^ 'Gets source code for multiple methods. Arguments must provide a methodDescriptors array of method descriptors with methodClassName, methodName, and classSide values.

methodClassName may name a class or a trait; classSide true means its class side. Only methods defined by that class or trait itself are returned. For an inherited method or a copy provided by a trait, the entry is an error whose definingMethodReference names the method that holds the source; ask for that method instead. For a method that a trait requires, definingMethodReference names the requirement in the trait. For a trait conflict, conflictingMethodReferences lists the conflicting methods, and conflictLocationReference, when present, names where they conflict.

Example JSON arguments:
{
  "methodDescriptors": [
    {"methodClassName": "Collection", "methodName": "withAll:", "classSide": true},
    {"methodClassName": "GtLMagritteToolForMethodsSource", "methodName": "privatePerformToolCall:inContext:", "classSide": false}
  ]
}

Example JSON response:
{
  "methods": [
    {"methodReference": {"methodName": "withAll:", "methodClassName": "Collection", "classSide": true}, "sourceCode": "..."},
    {"methodReference": {"methodName": "privatePerformToolCall:inContext:", "methodClassName": "GtLMagritteToolForMethodsSource", "classSide": false}, "sourceCode": "..."}
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
