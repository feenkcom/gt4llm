"
Examples for GtLMagritteToolForMethodCompilation.
"
Class {
	#name : #GtLMagritteToolForMethodCompilationExamples,
	#superclass : #GtLAbstractMagritteFunctionToolExamples,
	#traits : 'TGtLExceptionDomainObjectAssertions',
	#classTraits : 'TGtLExceptionDomainObjectAssertions classTrait',
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
	[ | call targetObject |
		call := self
			executeTool: GtLMagritteToolForMethodCompilation new
			withArguments: {
				'methodRequest' -> {
					'methodClassName' -> targetClass name asString.
					'sourceCode' -> source.
					'protocol' -> 'examples'.
					'classSide' -> true
				} asDictionary
			} asDictionary.
		targetObject := call result targetObject.
		self assert: (targetObject isKindOf: GtLMethodCompilationResult).
		self assert: targetObject status equals: 'compiled'.
		self assert: (metaClass includesSelector: selector).
		self assert: targetObject newMethod isClassSide.
		self assert: targetObject oldMethod isNil.
		^ call
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
	[ | call targetObject |
		call := self
			executeTool: GtLMagritteToolForMethodCompilation new
			withArguments: {
				'methodRequest' -> {
					'methodClassName' -> targetClass name asString.
					'sourceCode' -> source.
					'protocol' -> 'examples'.
					'classSide' -> false
				} asDictionary
			} asDictionary.
		targetObject := call result targetObject.
		self assert: (targetObject isKindOf: GtLMethodCompilationResult).
		self assert: targetObject status equals: 'compiled'.
		self assert: (targetClass includesSelector: selector).
		self assert: targetObject newMethod methodName equals: selector asString.
		self assert: targetObject oldMethod isNil.
		^ call
	] ensure: [
		(targetClass includesSelector: selector)
			ifTrue: [ targetClass removeSelector: selector ] ]
]

{ #category : #examples }
GtLMagritteToolForMethodCompilationExamples >> compileMethodForUnknownClass [
	<gtExample>
	| call |
	call := self
		executeTool: GtLMagritteToolForMethodCompilation new
		withArguments: {
			'methodRequest' -> {
				'methodClassName' -> 'ClassThatDoesNotExist'.
				'sourceCode' -> 'someMethod ^ 1'.
				'protocol' -> 'examples'.
				'classSide' -> false
			} asDictionary
		} asDictionary.
	self 
		assertMissingObject: call result targetObject 
		withObjectName: 'ClassThatDoesNotExist' 
		errorMessage: 'ClassThatDoesNotExist is not found'.
	^ call
]

{ #category : #examples }
GtLMagritteToolForMethodCompilationExamples >> compileMethodMissingArgument [
	<gtExample>
	| call |
	call := self
		executeTool: GtLMagritteToolForMethodCompilation new
		withArguments: Dictionary new.
	self 
		assertMissingRequiredProperties: call result targetObject 
		withPropertyNames: #('methodRequest') 
		path: #(nil) 
		errorMessage: 'required properties missing [methodRequest]'.
	^ call
]

{ #category : #examples }
GtLMagritteToolForMethodCompilationExamples >> compileMethodWithEmptyMethodRequest [
	<gtExample>
	| call |
	call := self
		executeTool: GtLMagritteToolForMethodCompilation new
		withArguments: { 'methodRequest' -> Dictionary new } asDictionary.
	self 
		assertMissingRequiredProperties: call result targetObject 
		withPropertyNames: #('classSide' 'methodClassName' 'protocol' 'sourceCode') 
		path: #('methodRequest') 
		errorMessage: '@[methodRequest] required properties missing [classSide, methodClassName, protocol, sourceCode]'.
	^ call
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
	[ | call targetObject |
		call := self
			executeTool: GtLMagritteToolForMethodCompilation new
			withArguments: {
				'methodRequest' -> {
					'methodClassName' -> targetClass name asString.
					'sourceCode' -> sourceAfter.
					'protocol' -> 'examples'.
					'classSide' -> false
				} asDictionary
			} asDictionary.
		targetObject := call result targetObject.
		self assert: (targetObject isKindOf: GtLMethodCompilationResult).
		self assert: targetObject status equals: 'compiled'.
		self assert: targetObject oldMethod sourceCode equals: sourceBefore.
		self assert: targetObject newMethod sourceCode equals: sourceAfter.
		^ call
	] ensure: [
		(targetClass includesSelector: selector)
			ifTrue: [ targetClass removeSelector: selector ] ]
]

{ #category : #examples }
GtLMagritteToolForMethodCompilationExamples >> compileMethodWithNilMethodRequest [
	<gtExample>
	| call |
	call := self
		executeTool: GtLMagritteToolForMethodCompilation new
		withArguments: { 'methodRequest' -> nil } asDictionary.
	self 
		assertJSONSchemaValidationError: call result targetObject 
		withPath: #('methodRequest') 
		errorMessage: '@[methodRequest] object expected'.
	^ call
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
	[ | call targetObject |
		call := self
			executeTool: GtLMagritteToolForMethodCompilation new
			withArguments: {
				'methodRequest' -> {
					'methodClassName' -> targetClass name asString.
					'sourceCode' -> sourceCode.
					'protocol' -> 'examples'.
					'classSide' -> false
				} asDictionary
			} asDictionary.
		targetObject := call result targetObject.
		self 
			assertMethodCompilationException: targetObject 
			withTargetClassName: targetClass name asString 
			sourceCode: sourceCode 
			description: 'Syntax error' 
			exceptionClass: SmaCCParserError
			messageSubstring: 'Token not expected'.
		self assert: (targetClass includesSelector: selector) not.
		^ call
	] ensure: [
		(targetClass includesSelector: selector)
			ifTrue: [ targetClass removeSelector: selector ] ]
]
