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
	<gsCode: ' | className targetClass behavior source protocol selector reference oldMethod newMethod classDescription |
 className := (request methodClassName ifNil: [ '''' ]) asString trimBoth.
 className = ''Trait'' ifTrue: [ ^ GtLProblemDomainObject new errorMessage: ''GemStone does not support Trait modification'' ].
 targetClass := GsSession currentSession objectNamed: className asSymbol.
 targetClass ifNil: [ ^ GtLMissingDomainObject new objectName: className ].
 targetClass isBehavior ifFalse: [ ^ GtLProblemDomainObject new errorMessage: ''Target must be a class'' ].
 targetClass isTrait ifTrue: [ ^ GtLProblemDomainObject new errorMessage: ''GemStone does not support Trait modification'' ].
 source := (request sourceCode ifNil: [ '''' ]) trimBoth.
 source isEmpty ifTrue: [ ^ GtLMissingDomainObject new objectName: ''sourceCode'' ].
 protocol := (request protocol ifNil: [ '''' ]) trimBoth.
 behavior := request isClassSide ifTrue: [ targetClass class ] ifFalse: [ targetClass ].
 classDescription := GtLClassDefinitionDescription fromClass: targetClass.
 [
 selector := behavior extractSelector: source.
 reference := GtLMethodReference new
 methodClassName: targetClass name asString;
 methodName: selector asString;
 classSide: request isClassSide;
 yourself.
 oldMethod := (behavior includesSelector: selector environmentId: 0)
 ifTrue: [ GtLMethodWithSource new
 methodReference: reference;
 sourceCode: (behavior compiledMethodAt: selector environmentId: 0) sourceString;
 yourself ] ifFalse: [ nil ].
 protocol isEmpty ifTrue: [ protocol := oldMethod
 ifNil: [ ''as yet unclassified'' ]
 ifNotNil: [ (behavior categoryOfSelector: selector environmentId: 0) asString ] ].
 behavior compileMethod: source category: protocol asSymbol environmentId: 0.
 newMethod := GtLMethodWithSource new
 methodReference: reference;
 sourceCode: (behavior compiledMethodAt: selector environmentId: 0) sourceString;
 yourself
 ] on: Error do: [ :error |
 ^ GtLMethodCompilationExceptionDomainObject new
 freeze: error;
 targetClass: behavior;
 protocolName: protocol;
 sourceCode: source;
 description: ((error isKindOf: CompileError)
 ifTrue: [ ''Syntax error while compiling given method source code'' ]
 ifFalse: [ ''Compilation error while compiling given method source code'' ]) ].
 ^ GtLMethodCompilationResult new
 targetClass: classDescription;
 oldMethod: oldMethod;
 newMethod: newMethod;
 status: ''compiled'';
 yourself'>
	| extractor selector compiledMethod newMethodWithSource classDescription |
	extractor := GtLMethodCompilationDataExtractor new.
	extractor request: request.

	extractor extractAllIfError: [ :error | ^ error ].	"Capture class description before compilation"
	classDescription := GtLClassDefinitionDescription
			fromClass: extractor targetClass.

	selector := [ [ extractor
			sourceCode: (self formatSourceCode: extractor sourceCode).
		extractor targetClass
			compile: extractor sourceCode
			classified: extractor protocol ]
			on: RBParser gtParseErrorClass
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
		targetClass: classDescription;
		oldMethod: extractor oldMethodWithSource;
		newMethod: newMethodWithSource;
		status: 'compiled';
		yourself
]

{ #category : #accessing }
GtLMagritteToolForMethodCompilation >> description [
	^ 'Compiles the provided method source code in the specified class or metaclass and reports the result.

Arguments:
- methodRequest: object with methodClassName, sourceCode, classSide and an optional protocol

The protocol is optional. Omit it when modifying an existing method: the method keeps its current protocol. Do not guess a protocol for an existing method; changing the protocol of an extension method (a protocol starting with ''*'') moves it to a different package. Provide a protocol only for a new method, or to deliberately change the protocol of an existing method.

Example JSON arguments (modifying an existing method):
{
  "methodRequest": {
    "methodClassName": "MyClass",
    "sourceCode": "myMethod ^ 42",
    "classSide": false
  }
}

Example JSON arguments (new method):
{
  "methodRequest": {
    "methodClassName": "MyClass",
    "sourceCode": "myNewMethod ^ 42",
    "protocol": "accessing",
    "classSide": false
  }
}

Example JSON response:
{
  "status": "compiled"
}'
]

{ #category : #private }
GtLMagritteToolForMethodCompilation >> formatSourceCode: aString [
	^ (RBParser parseMethod: aString) formattedCode
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
