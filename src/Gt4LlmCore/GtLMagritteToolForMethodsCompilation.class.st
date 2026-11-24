"
Magritte-based tool for compiling multiple methods across classes.
"
Class {
	#name : #GtLMagritteToolForMethodsCompilation,
	#superclass : #GtLAbstractMagritteFunctionTool,
	#category : #'Gt4LlmCore-Tools'
}

{ #category : #accessing }
GtLMagritteToolForMethodsCompilation >> description [
	^ 'Compiles multiple method sources across classes and reports each result.

A method provided by a trait is defined in the trait: compile it in the trait to change it for every class that uses the trait. Compiling it in a class that uses the trait adds an overriding method to that class only.

Arguments:
- methods: array of method compilation requests, each with methodClassName, sourceCode, classSide and protocol

Provide a protocol for a new method, including one that overrides an inherited or trait-provided method; without one the new method is not compiled. Omit the protocol when modifying an existing method: the method keeps its current protocol. Do not guess a protocol for an existing method; changing the protocol of an extension method (a protocol starting with *) moves it to a different package.

Example JSON arguments (modifying an existing method, then adding a new one):
{
  "methods": [
    {"methodClassName": "MyClass", "sourceCode": "myMethod ^ 42", "classSide": false},
    {"methodClassName": "MyClass", "sourceCode": "anotherMethod ^ 1", "protocol": "accessing", "classSide": false}
  ]
}

Example JSON response:
{
  "methodCompilationResults": [
    {"status": "compiled", "targetMethodReference": {"methodClassName": "MyClass", "methodName": "myMethod", "classSide": false}},
    {"status": "compiled", "targetMethodReference": {"methodClassName": "MyClass", "methodName": "anotherMethod", "classSide": false}}
  ]
}'
]

{ #category : #magritte }
GtLMagritteToolForMethodsCompilation >> methodsDescription [
	<magritteDescription>
	^ MAToManyRelationDescription new
		accessor: #methods;
		classes: { GtLMethodCompilationRequest };
		beRequired
]

{ #category : #accessing }
GtLMagritteToolForMethodsCompilation >> name [
	^ 'compileMethods'
]

{ #category : #'tool execution' }
GtLMagritteToolForMethodsCompilation >> privatePerformToolCall: aToolCall inContext: anExecutionContext [
	| methodRequests results compilationTool |
	
	methodRequests := aToolCall arguments at: 'methods'.
	compilationTool := GtLMagritteToolForMethodCompilation new.
	
	results := methodRequests collect: [ :request |
		compilationTool compileMethodFromRequest: request ].
	
	^ GtLMethodsCompilationResult new
		methods: results asArray;
		yourself
]
