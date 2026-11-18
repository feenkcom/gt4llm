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

Arguments:
- methods: array of method compilation requests, each with methodClassName, sourceCode, classSide and an optional protocol

The protocol is optional. Omit it when modifying an existing method: the method keeps its current protocol. Do not guess a protocol for an existing method; changing the protocol of an extension method (a protocol starting with *) moves it to a different package. Provide a protocol only for a new method, or to deliberately change the protocol of an existing method.

Example JSON arguments (modifying an existing method, then adding a new one):
{
  "methods": [
    {"methodClassName": "MyClass", "sourceCode": "myMethod ^ 42", "classSide": false},
    {"methodClassName": "MyClass", "sourceCode": "anotherMethod ^ 1", "protocol": "accessing", "classSide": false}
  ]
}

Example JSON response:
{
  "methods": [
    {"status": "compiled"},
    {"status": "compiled"}
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
