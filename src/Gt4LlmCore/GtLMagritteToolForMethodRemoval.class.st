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

Only a method defined in the class itself (or in its metaclass when classSide is true) is removed. A method inherited from a superclass or provided by a trait is not removed; the error names the method that defines it, or the conflicting trait methods. Removing a method from a trait removes it, and its aliases, from every class that uses the trait, except where a class overrides it.

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
  "status": "removed",
  "targetMethodReference": {"methodClassName": "MyClass", "methodName": "myMethod", "classSide": false}
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
	^ self removeMethodFromDescriptor: (aToolCall arguments at: 'methodDescriptor')
]

{ #category : #private }
GtLMagritteToolForMethodRemoval >> removeMethod: aMethod [
	| behavior methodWithSource classDescription |
	behavior := aMethod methodClass.
	methodWithSource := GtLMethodWithSource fromCompiledMethod: aMethod.
	classDescription := GtLClassDefinitionDescription
			fromClass: behavior instanceSide.
	[ behavior removeSelector: aMethod selector ]
		on: Error
		do: [ :ex | 
			^ GtLExceptionDomainObject new
				freeze: ex;
				errorReason: 'Error while removing method' ].
	^ GtLMethodRemovalResult new
		targetClass: classDescription;
		removedMethod: methodWithSource;
		status: 'removed';
		yourself
]

{ #category : #'tool execution' }
GtLMagritteToolForMethodRemoval >> removeMethodFromDescriptor: methodDescriptor [
	^ methodDescriptor
		compiledMethodIfPresent: [ :aMethod | self removeMethod: aMethod ]
		ifMissing: [ :anErrorResult | anErrorResult ]
]
