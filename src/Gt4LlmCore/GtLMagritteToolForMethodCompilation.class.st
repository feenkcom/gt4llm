"
Magritte-based tool for compiling a method into a class.
"
Class {
	#name : #GtLMagritteToolForMethodCompilation,
	#superclass : #GtLAbstractMagritteFunctionTool,
	#category : #'Gt4LlmCore-Tools'
}

{ #category : #private }
GtLMagritteToolForMethodCompilation >> compileMethodFromRequest: request [
	| extractor selector compiledMethod newMethodWithSource |
	
	extractor := GtLMethodCompilationDataExtractor new.
	extractor request: request.
	
	extractor extractAllIfError: [ :error | ^ error ].
	
	selector := [ [ extractor targetClass 
			compile: extractor sourceCode classified: extractor protocol ]
		on: CodeError
		do: [ :notification |
			^ GtLMethodCompilationExceptionDomainObject new
				freeze: notification;
				targetClass: extractor targetClass;
				protocolName: extractor protocol;
				sourceCode: extractor sourceCode;
				description: 'Syntax error while compiling given method source code' ] ]
		on: Error
		do: [ :error |
			^ GtLMethodCompilationExceptionDomainObject new
				freeze: error;
				targetClass: extractor targetClass;
				protocolName: extractor protocol;
				sourceCode: extractor sourceCode;
				description: 'Compilation error while compiling given method source code' ].
	
	compiledMethod := extractor targetClass methodDict at: selector.
	newMethodWithSource := GtLMethodWithSource fromCompiledMethod: compiledMethod.
	
	^ GtLMethodCompilationResult new
		oldMethod: extractor oldMethodWithSource;
		newMethod: newMethodWithSource;
		status: 'compiled';
		yourself
]

{ #category : #accessing }
GtLMagritteToolForMethodCompilation >> description [
	^ 'Compiles the provided method source code in the specified class or metaclass and reports the result.

Arguments:
- methodRequest: object with methodClassName, sourceCode, protocol, and classSide

Example JSON arguments:
{
  "methodRequest": {
    "methodClassName": "MyClass",
    "sourceCode": "myMethod ^ 42",
    "protocol": "accessing",
    "classSide": false
  }
}

Example JSON response:
{
  "status": "compiled"
}'
]

{ #category : #magritte }
GtLMagritteToolForMethodCompilation >> methodRequestDescription [
	<magritteDescription>
	^ MAToOneRelationDescription new
		accessor: #methodRequest;
		classes: { GtLMethodCompilationRequest };
		beRequired
]

{ #category : #accessing }
GtLMagritteToolForMethodCompilation >> name [
	^ 'compileMethod'
]

{ #category : #'tool api' }
GtLMagritteToolForMethodCompilation >> privatePerformToolCall: aToolCall inContext: anExecutionContext [
	| request |
	request := aToolCall arguments at: 'methodRequest'.
	^ self compileMethodFromRequest: request
]
