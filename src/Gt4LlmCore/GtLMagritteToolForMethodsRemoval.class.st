"
Magritte-based tool for removing multiple methods from classes.
"
Class {
	#name : #GtLMagritteToolForMethodsRemoval,
	#superclass : #GtLAbstractMagritteFunctionTool,
	#category : #'Gt4LlmCore-Tools'
}

{ #category : #accessing }
GtLMagritteToolForMethodsRemoval >> description [
	^ 'Removes multiple methods across classes and reports each result.

Arguments:
- methods: array of method descriptors with methodClassName, methodName, and classSide

Example JSON arguments:
{
  "methods": [
    {"methodClassName": "MyClass", "methodName": "method1", "classSide": false},
    {"methodClassName": "MyClass", "methodName": "method2", "classSide": true}
  ]
}

Example JSON response:
{
  "methods": [
    {"status": "removed"},
    {"status": "removed"}
  ]
}'
]

{ #category : #magritte }
GtLMagritteToolForMethodsRemoval >> methodsDescription [
	<magritteDescription>
	^ MAToManyRelationDescription new
		accessor: #methods;
		classes: { GtLMethodReference };
		beRequired
]

{ #category : #accessing }
GtLMagritteToolForMethodsRemoval >> name [
	^ 'removeMethods'
]

{ #category : #'tool api' }
GtLMagritteToolForMethodsRemoval >> privatePerformToolCall: aToolCall inContext: anExecutionContext [
	| methodDescriptors results |
	
	methodDescriptors :=  aToolCall arguments at: 'methods'.
	results := methodDescriptors collect: [ :methodDescriptor |
		self removeMethodFromDescriptor: methodDescriptor ].
		
	^ GtLMethodsRemovalResult new
		methods: results asArray;
		yourself
]

{ #category : #private }
GtLMagritteToolForMethodsRemoval >> removeMethodFromDescriptor: methodDescriptor [
	<gsCode: ' | className targetClass behavior selector removedMethod classDescription |
 className := methodDescriptor methodClassName.
 className = ''Trait'' ifTrue: [
 ^ GtLProblemDomainObject new errorMessage: ''GemStone does not support Trait modification'' ].
 targetClass := GsSession currentSession objectNamed: className asSymbol.
 targetClass ifNil: [ ^ GtLMissingDomainObject new objectName: className ].
 targetClass isBehavior ifFalse: [ ^ GtLProblemDomainObject new errorMessage: ''Target must be a class'' ].
 targetClass isTrait ifTrue: [
 ^ GtLProblemDomainObject new errorMessage: ''GemStone does not support Trait modification'' ].
 behavior := methodDescriptor isClassSide ifTrue: [ targetClass class ] ifFalse: [ targetClass ].
 selector := methodDescriptor methodName asSymbol.
 (behavior includesSelector: selector environmentId: 0) ifFalse: [
 ^ GtLMissingDomainObject new objectName: methodDescriptor methodSignature ].
 removedMethod := GtLMethodWithSource new
 methodReference: methodDescriptor;
 sourceCode: (behavior compiledMethodAt: selector environmentId: 0) sourceString;
 yourself.
 classDescription := GtLClassDefinitionDescription fromClass: targetClass.
 [ behavior removeSelector: selector environmentId: 0 ]
 on: Error do: [ :error |
 ^ GtLExceptionDomainObject new
 freeze: error;
 errorReason: ''Error while removing method'' ].
 ^ GtLMethodRemovalResult new
 targetClass: classDescription;
 removedMethod: removedMethod;
 status: ''removed'';
 yourself'>
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
