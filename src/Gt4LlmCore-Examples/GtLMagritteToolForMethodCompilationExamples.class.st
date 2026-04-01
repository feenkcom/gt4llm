"
Examples for GtLMagritteToolForMethodCompilation.
"
Class {
	#name : #GtLMagritteToolForMethodCompilationExamples,
	#superclass : #Object,
	#traits : 'TGtLInvalidInputDataAssertions + TGtLExceptionDomainObjectAssertions',
	#classTraits : 'TGtLInvalidInputDataAssertions classTrait + TGtLExceptionDomainObjectAssertions classTrait',
	#category : #'Gt4LlmCore-Examples-Tools'
}

{ #category : #assertions }
GtLMagritteToolForMethodCompilationExamples >> assertMethodCompilationException: aDomainObject withTargetClassName: aClassName sourceCode: aSourceCode description: aDescription exceptionClass: anExceptionClass messageSubstring: aMessageSubstring [
	"Assert that the domain object is a GtLMethodCompilationExceptionDomainObject with expected values."
	
	self assert: (aDomainObject isKindOf: GtLMethodCompilationExceptionDomainObject).
	self assert: aDomainObject targetClassName equals: aClassName.
	self assert: aDomainObject sourceCode equals: aSourceCode.
	self assert: (aDomainObject description beginsWith: aDescription).
	self 
		assertExceptionDomainObject: aDomainObject 
		withExceptionClass: anExceptionClass 
		messageSubstring: aMessageSubstring
]

{ #category : #examples }
GtLMagritteToolForMethodCompilationExamples >> compileClassSideMethod [
	<gtExample>
	| selector targetClass metaClass source |
	selector := #gtMagritteCompiledExampleClassSideMethod.
	targetClass := GtLMagritteToolForMethodCompilationExamples.
	metaClass := targetClass class.
	source := 'gtMagritteCompiledExampleClassSideMethod ^ ''class'''.
	(metaClass includesSelector: selector)
		ifTrue: [ metaClass removeSelector: selector ].
	[ | tool call result domainObject |
		tool := GtLMagritteToolForMethodCompilation new.
		call := GtLFunctionToolCall new.
		call rawArguments: {
			'methodRequest' -> {
				'methodClassName' -> targetClass name asString.
				'sourceCode' -> source.
				'protocol' -> 'examples'.
				'classSide' -> true
			} asDictionary
		} asDictionary.
		result := tool performToolCall: call.
		self assert: call tool == tool.
		self assert: (result isKindOf: GTLDataViewWrapperModel).
		domainObject := result targetObject.
		self assert: (domainObject isKindOf: GtLMethodCompilationResult).
		self assert: domainObject status equals: 'compiled'.
		self assert: (metaClass includesSelector: selector).
		self assert: domainObject newMethod isClassSide.
		self assert: domainObject oldMethod isNil.
		^ domainObject
	] ensure: [
		(metaClass includesSelector: selector)
			ifTrue: [ metaClass removeSelector: selector ] ]
]

{ #category : #examples }
GtLMagritteToolForMethodCompilationExamples >> compileInstanceSideMethod [
	<gtExample>
	| selector targetClass source |
	selector := #gtMagritteCompiledExampleInstanceMethod.
	targetClass := GtLMagritteToolForMethodCompilationExamples.
	source := 'gtMagritteCompiledExampleInstanceMethod ^ 42'.
	(targetClass includesSelector: selector)
		ifTrue: [ targetClass removeSelector: selector ].
	[ | tool call result domainObject |
		tool := GtLMagritteToolForMethodCompilation new.
		call := GtLFunctionToolCall new.
		call rawArguments: {
			'methodRequest' -> {
				'methodClassName' -> targetClass name asString.
				'sourceCode' -> source.
				'protocol' -> 'examples'.
				'classSide' -> false
			} asDictionary
		} asDictionary.
		result := tool performToolCall: call.
		self assert: call tool == tool.
		self assert: (result isKindOf: GTLDataViewWrapperModel).
		domainObject := result targetObject.
		self assert: (domainObject isKindOf: GtLMethodCompilationResult).
		self assert: domainObject status equals: 'compiled'.
		self assert: (targetClass includesSelector: selector).
		self assert: domainObject newMethod methodName equals: selector asString.
		self assert: domainObject oldMethod isNil.
		^ domainObject
	] ensure: [
		(targetClass includesSelector: selector)
			ifTrue: [ targetClass removeSelector: selector ] ]
]

{ #category : #examples }
GtLMagritteToolForMethodCompilationExamples >> compileMethodForUnknownClass [
	<gtExample>
	| tool call result domainObject |
	tool := GtLMagritteToolForMethodCompilation new.
	call := GtLFunctionToolCall new.
	call rawArguments: {
		'methodRequest' -> {
			'methodClassName' -> 'ClassThatDoesNotExist'.
			'sourceCode' -> 'someMethod ^ 1'.
			'protocol' -> 'examples'.
			'classSide' -> false
		} asDictionary
	} asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: (result isKindOf: GTLDataViewWrapperModel).
	domainObject := result targetObject.
	self 
		assertMissingObject: domainObject 
		withObjectName: 'ClassThatDoesNotExist' 
		errorMessage: 'ClassThatDoesNotExist is not found'.
	^ domainObject
]

{ #category : #examples }
GtLMagritteToolForMethodCompilationExamples >> compileMethodMissingArgument [
	<gtExample>
	| tool call result domainObject |
	tool := GtLMagritteToolForMethodCompilation new.
	call := GtLFunctionToolCall new.
	call rawArguments: Dictionary new.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: (result isKindOf: GTLDataViewWrapperModel).
	domainObject := result targetObject.
	self 
		assertMissingRequiredProperties: domainObject 
		withPropertyNames: #('methodRequest') 
		path: #(nil) 
		errorMessage: 'required properties missing [methodRequest]'.
	^ domainObject
]

{ #category : #examples }
GtLMagritteToolForMethodCompilationExamples >> compileMethodWithEmptyMethodRequest [
	<gtExample>
	| tool call result domainObject |
	tool := GtLMagritteToolForMethodCompilation new.
	call := GtLFunctionToolCall new.
	call rawArguments: { 'methodRequest' -> Dictionary new } asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: (result isKindOf: GTLDataViewWrapperModel).
	domainObject := result targetObject.
	self 
		assertMissingRequiredProperties: domainObject 
		withPropertyNames: #('classSide' 'methodClassName' 'protocol' 'sourceCode') 
		path: #('methodRequest') 
		errorMessage: '@[methodRequest] required properties missing [classSide, methodClassName, protocol, sourceCode]'.
	^ domainObject
]

{ #category : #examples }
GtLMagritteToolForMethodCompilationExamples >> compileMethodWithExistingSource [
	<gtExample>
	| selector targetClass sourceBefore sourceAfter |
	selector := #gtMagritteCompiledExampleExisting.
	targetClass := GtLMagritteToolForMethodCompilationExamples.
	sourceBefore := 'gtMagritteCompiledExampleExisting ^ 1'.
	sourceAfter := 'gtMagritteCompiledExampleExisting ^ 2'.
	targetClass compile: sourceBefore classified: 'examples'.
	[ | tool call result domainObject |
		tool := GtLMagritteToolForMethodCompilation new.
		call := GtLFunctionToolCall new.
		call rawArguments: {
			'methodRequest' -> {
				'methodClassName' -> targetClass name asString.
				'sourceCode' -> sourceAfter.
				'protocol' -> 'examples'.
				'classSide' -> false
			} asDictionary
		} asDictionary.
		result := tool performToolCall: call.
		self assert: call tool == tool.
		self assert: (result isKindOf: GTLDataViewWrapperModel).
		domainObject := result targetObject.
		self assert: (domainObject isKindOf: GtLMethodCompilationResult).
		self assert: domainObject status equals: 'compiled'.
		self assert: domainObject oldMethod sourceCode equals: sourceBefore.
		self assert: domainObject newMethod sourceCode equals: sourceAfter.
		^ domainObject
	] ensure: [
		(targetClass includesSelector: selector)
			ifTrue: [ targetClass removeSelector: selector ] ]
]

{ #category : #examples }
GtLMagritteToolForMethodCompilationExamples >> compileMethodWithNilMethodRequest [
	<gtExample>
	| tool call result domainObject |
	tool := GtLMagritteToolForMethodCompilation new.
	call := GtLFunctionToolCall new.
	call rawArguments: { 'methodRequest' -> nil } asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: (result isKindOf: GTLDataViewWrapperModel).
	domainObject := result targetObject.
	self 
		assertJSONSchemaValidationError: domainObject 
		withPath: #('methodRequest') 
		errorMessage: '@[methodRequest] object expected'.
	^ domainObject
]

{ #category : #examples }
GtLMagritteToolForMethodCompilationExamples >> compileMethodWithSyntaxError [
	<gtExample>
	| selector targetClass sourceCode |
	targetClass := GtLMagritteToolForMethodCompilationExamples.
	selector := #gtMagritteCompiledExampleWithSyntaxError.
	sourceCode := 'gtMagritteCompiledExampleWithSyntaxError ^'.
	(targetClass includesSelector: selector)
		ifTrue: [ targetClass removeSelector: selector ].
	[ | tool call result domainObject |
		tool := GtLMagritteToolForMethodCompilation new.
		call := GtLFunctionToolCall new.
		call rawArguments: {
			'methodRequest' -> {
				'methodClassName' -> targetClass name asString.
				'sourceCode' -> sourceCode.
				'protocol' -> 'examples'.
				'classSide' -> false
			} asDictionary
		} asDictionary.
		result := tool performToolCall: call.
		self assert: call tool == tool.
		self assert: (result isKindOf: GTLDataViewWrapperModel).
		domainObject := result targetObject.
		self 
			assertMethodCompilationException: domainObject 
			withTargetClassName: targetClass name asString 
			sourceCode: sourceCode 
			description: 'Syntax error' 
			exceptionClass: SmaCCParserError
			messageSubstring: 'Token not expected'.
		self assert: (targetClass includesSelector: selector) not.
		^ domainObject
	] ensure: [
		(targetClass includesSelector: selector)
			ifTrue: [ targetClass removeSelector: selector ] ]
]
