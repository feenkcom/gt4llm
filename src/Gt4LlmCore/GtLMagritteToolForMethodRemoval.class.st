"
Magritte-based tool for removing a method from a class.
"
Class {
	#name : #GtLMagritteToolForMethodRemoval,
	#superclass : #GtLAbstractMagritteFunctionTool,
	#category : #Gt4LlmCore
}

{ #category : #accessing }
GtLMagritteToolForMethodRemoval >> description [
	^ 'Removes a method from the specified class.

Arguments:
- methodDescriptor: object with methodClassName, methodName, and classSide values

Example JSON arguments:
{
  "methodDescriptor": {
    "methodClassName": "MyClass",
    "methodName": "myMethod",
    "classSide": false
  }
}

Example JSON response:
{
  "status": "removed"
}'
]

{ #category : #magritte }
GtLMagritteToolForMethodRemoval >> methodDescriptorDescription [
	<magritteDescription>
	^ MAToOneRelationDescription new
		accessor: #methodDescriptor;
		classes: { GtLMethodReference };
		beRequired
]

{ #category : #accessing }
GtLMagritteToolForMethodRemoval >> name [
	^ 'removeMethod'
]

{ #category : #'tool api' }
GtLMagritteToolForMethodRemoval >> privatePerformToolCall: aToolCall inContext: anExecutionContext [
	| methodDescriptor |
	methodDescriptor := aToolCall arguments at: 'methodDescriptor'.
	
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
						description: 'Error while removing method';
						yourself ].
			GtLMethodRemovalResult new
				removedMethod: methodWithSource;
				status: 'removed';
				yourself ]
		ifMissing: [ :errorResult | errorResult ]
]
