"
Magritte-based tool for compiling a method into a class.
"
Class {
	#name : #GtLMagritteToolForMethodCompilation,
	#superclass : #GtLAbstractMagritteFunctionTool,
	#category : #'Gt4LlmCore-Tools'
}

{ #category : #'tool execution' }
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
 protocol isEmpty ifTrue: [ protocol := ''as yet unclassified'' ].
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
	
	extractor extractAllIfError: [ :error | ^ error ].
	
	"Capture class description before compilation"
	classDescription := GtLClassDefinitionDescription fromClass: extractor targetClass.
	
	selector := [ [ extractor targetClass 
			compile: extractor sourceCode classified: extractor protocol ]
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
