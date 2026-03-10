"
Magritte-based tool for compiling a method into a class.
"
Class {
	#name : #GtLMagritteToolForMethodCompilation,
	#superclass : #GtLAbstractMagritteFunctionTool,
	#category : #Gt4LlmCore
}

{ #category : #private }
GtLMagritteToolForMethodCompilation >> compileMethodFromRequest: request [
	| className class source protocol methodNode oldMethodWithSource selector compiledMethod newMethodWithSource |
	
	className := request methodClassName.
	(className isNil or: [ className trimBoth isEmpty ])
		ifTrue: [ ^ GtLMissingDomainObject new objectName: (className ifNil: [ '' ]) ].
	class := className asClassIfAbsent: [ ^ GtLMissingDomainObject new objectName: className ].
	request isClassSide ifTrue: [ class := class class ].
	source := request sourceCode.
	(source isNil or: [ source trimBoth isEmpty ])
		ifTrue: [ ^ GtLMissingDomainObject new objectName: 'sourceCode' ].
	source := source trimBoth.
	protocol := request protocol.
	(protocol isNil or: [ protocol trimBoth isEmpty ])
		ifTrue: [ protocol := 'as yet unclassified' ].
		
	methodNode := [ GtPharoParser
		parse: source
		startingAt: GtPharoParser startingStateForMethod ]
		on: Error
		do: [ :error |
			^ GtLMethodCompilationExceptionDomainObject new
				freeze: error;
				targetClass: class;
				protocolName: protocol;
				sourceCode: source;
				description: 'Syntax error while parsing the given method source code' ].
				
	oldMethodWithSource := (methodNode notNil
		and: [ methodNode selector notNil
			and: [ class includesSelector: methodNode selector ] ])
		ifTrue: [ GtLMethodWithSource fromCompiledMethod: (class >> methodNode selector) ]
		ifFalse: [ nil ].
	selector := [ [ class compile: source classified: protocol ]
		on: CodeError
		do: [ :notification |
			^ GtLMethodCompilationExceptionDomainObject new
				freeze: notification;
				targetClass: class;
				protocolName: protocol;
				sourceCode: source;
				description: 'Syntax error while compiling given method source code' ] ]
		on: Error
		do: [ :error |
			^ GtLMethodCompilationExceptionDomainObject new
				freeze: error;
				targetClass: class;
				protocolName: protocol;
				sourceCode: source;
				description: 'Compilation error while compiling given method source code' ].
	compiledMethod := class methodDict at: selector.
	newMethodWithSource := GtLMethodWithSource fromCompiledMethod: compiledMethod.
	^ GtLMethodCompilationResult new
		oldMethod: oldMethodWithSource;
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
