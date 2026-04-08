"
Magritte-based tool for removing multiple methods from classes.
"
Class {
	#name : #GtLMagritteToolForMethodsRemoval,
	#superclass : #GtLAbstractMagritteFunctionTool,
	#category : #'Gt4LlmCore-Tools'
}

{ #category : #accessing }
GtLMagritteToolForMethodsRemoval >> description [
	^ 'Removes multiple methods across classes and reports each result.

Arguments:
- methods: array of method descriptors with methodClassName, methodName, and classSide

Example JSON arguments:
{
  "methods": [
    {"methodClassName": "MyClass", "methodName": "method1", "classSide": false},
    {"methodClassName": "MyClass", "methodName": "method2", "classSide": true}
  ]
}

Example JSON response:
{
  "methods": [
    {"status": "removed"},
    {"status": "removed"}
  ]
}'
]

{ #category : #accessing }
GtLMagritteToolForMethodsRemoval >> isUsingDataViews [
	^ true
]

{ #category : #magritte }
GtLMagritteToolForMethodsRemoval >> methodsDescription [
	<magritteDescription>
	^ MAToManyRelationDescription new
		accessor: #methods;
		classes: { GtLMethodReference };
		beRequired
]

{ #category : #accessing }
GtLMagritteToolForMethodsRemoval >> name [
	^ 'removeMethods'
]

{ #category : #'tool api' }
GtLMagritteToolForMethodsRemoval >> privatePerformToolCall: aToolCall inContext: anExecutionContext [
	| methodDescriptors results |
	
	methodDescriptors :=  aToolCall arguments at: 'methods'.
	results := methodDescriptors collect: [ :methodDescriptor |
		self removeMethodFromDescriptor: methodDescriptor ].
		
	^ GtLMethodsRemovalResult new
		methods: results asArray;
		yourself
]

{ #category : #private }
GtLMagritteToolForMethodsRemoval >> removeMethodFromDescriptor: methodDescriptor [
	^ methodDescriptor
		compiledMethodIfPresent: [ :compiledMethod |
			| methodWithSource behavior |
			methodWithSource := GtLMethodWithSource fromCompiledMethod: compiledMethod.
			behavior := compiledMethod methodClass.
			[ behavior removeSelector: compiledMethod selector ]
				on: Error
				do: [ :ex |
					^ GtLExceptionDomainObject new
						freeze: ex;
						errorReason: 'Error while removing method' ].
			GtLMethodRemovalResult new
				removedMethod: methodWithSource;
				status: 'removed';
				yourself ]
		ifMissing: [ :errorResult | errorResult ]
]
