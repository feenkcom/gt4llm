"
Magritte-based tool for removing a method from a class.
"
Class {
	#name : #GtLMagritteToolForMethodRemoval,
	#superclass : #GtLAbstractMagritteFunctionTool,
	#category : #'Gt4LlmCore-Tools'
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

{ #category : #'tool execution' }
GtLMagritteToolForMethodRemoval >> privatePerformToolCall: aToolCall inContext: anExecutionContext [
	| methodDescriptor |
	methodDescriptor := aToolCall arguments at: 'methodDescriptor'.
	
	^ methodDescriptor
		compiledMethodIfPresent: [ :compiledMethod |
			| methodWithSource behavior classDescription |
			methodWithSource := GtLMethodWithSource fromCompiledMethod: compiledMethod.
			behavior := compiledMethod methodClass.
			classDescription := GtLClassDefinitionDescription fromClass: behavior.
			[ behavior removeSelector: compiledMethod selector ]
				on: Error
				do: [ :ex |
					^ GtLExceptionDomainObject new
						freeze: ex;
						errorReason: 'Error while removing method' ].
			GtLMethodRemovalResult new
				targetClass: classDescription;
				removedMethod: methodWithSource;
				status: 'removed';
				yourself ]
		ifMissing: [ :errorResult | errorResult ]
]
