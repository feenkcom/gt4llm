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
- methods: array of method compilation requests

Example JSON arguments:
{
  "methods": [
    {"methodClassName": "MyClass", "sourceCode": "myMethod ^ 42", "protocol": "accessing", "classSide": false},
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

{ #category : #accessing }
GtLMagritteToolForMethodsCompilation >> isUsingDataViews [
	^ true
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
