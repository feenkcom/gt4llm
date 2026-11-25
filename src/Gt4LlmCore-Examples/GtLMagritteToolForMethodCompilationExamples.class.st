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
	self assert: aDomainObject targetClassName equals: aClassName asSymbol.
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
	[ | call targetObject formattedSource |
	call := self
			executeTool: GtLMagritteToolForMethodCompilation new
			withArguments: {'methodRequest'
						-> {'methodClassName' -> targetClass name asString.
								'sourceCode' -> source.
								'protocol' -> 'examples'.
								'classSide' -> true} asDictionary} asDictionary.
	targetObject := call result targetObject.
	formattedSource := (RBParser parseMethod: source) formattedCode.
	self assert: (targetObject isKindOf: GtLMethodCompilationResult).
	self assert: targetObject status equals: 'compiled'.
	self assert: (metaClass includesSelector: selector).
	self assert: targetObject newMethod isClassSide.
	self assert: targetObject newMethod sourceCode equals: formattedSource.
	self assert: (metaClass >> selector) sourceCode equals: formattedSource.
	self assert: targetObject oldMethod isNil.
	^ call ]
		ensure: [ (metaClass includesSelector: selector)
				ifTrue: [ metaClass removeSelector: selector ] ]
]

{ #category : #examples }
GtLMagritteToolForMethodCompilationExamples >> compileExistingMethodWithoutProtocolKeepsProtocol [
	"Modifying an existing method without a protocol keeps its current protocol"

	<gtExample>
	| selector targetClass |
	selector := #gtMagritteCompiledExampleKeepsProtocol.
	targetClass := GtLMagritteToolForMethodCompilationExamples.
	targetClass
		compile: 'gtMagritteCompiledExampleKeepsProtocol ^ 1'
		classified: 'examples'.
	[ | call targetObject |
	call := self
			executeTool: GtLMagritteToolForMethodCompilation new
			withArguments: {'methodRequest'
						-> {'methodClassName' -> targetClass name asString.
								'sourceCode' -> 'gtMagritteCompiledExampleKeepsProtocol ^ 2'.
								'classSide' -> false} asDictionary} asDictionary.
	targetObject := call result targetObject.
	self assert: (targetObject isKindOf: GtLMethodCompilationResult).
	self assert: targetObject status equals: 'compiled'.
	self assert: targetObject oldMethod notNil.
	self assert: (targetClass >> selector) protocolName equals: #examples.
	^ call ]
		ensure: [ (targetClass includesSelector: selector)
				ifTrue: [ targetClass removeSelector: selector ] ]
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
			withArguments: {'methodRequest' -> Dictionary new} asDictionary.
	self
		assertMissingRequiredProperties: call result targetObject
		withPropertyNames: #('classSide' 'methodClassName' 'sourceCode')
		path: #('methodRequest')
		errorMessage: '@[methodRequest] required properties missing [classSide, methodClassName, sourceCode]'.
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
	[ | call targetObject formattedSource |
	call := self
			executeTool: GtLMagritteToolForMethodCompilation new
			withArguments: {'methodRequest'
						-> {'methodClassName' -> targetClass name asString.
								'sourceCode' -> sourceAfter.
								'protocol' -> 'examples'.
								'classSide' -> false} asDictionary} asDictionary.
	targetObject := call result targetObject.
	formattedSource := (RBParser parseMethod: sourceAfter) formattedCode.
	self assert: (targetObject isKindOf: GtLMethodCompilationResult).
	self assert: targetObject status equals: 'compiled'.
	self assert: targetObject oldMethod sourceCode equals: sourceBefore.
	self assert: targetObject newMethod sourceCode equals: formattedSource.
	self assert: (targetClass >> selector) sourceCode equals: formattedSource.
	^ call ]
		ensure: [ (targetClass includesSelector: selector)
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

{ #category : #examples }
GtLMagritteToolForMethodCompilationExamples >> compileNewClassSideTraitMethodWithoutProtocol [
	"The error for a new method without a protocol names it as the request does, also on the class side of a trait"

	<gtExample>
	^ GtLTraitMethodExamplesSubjects new
		during: [ :subjects | 
			| call targetObject |
			call := self
					executeTool: GtLMagritteToolForMethodCompilation new
					withArguments: {'methodRequest'
								-> {'methodClassName' -> subjects trait name asString.
										'sourceCode' -> 'newClassTraitMethod ^ 2'.
										'classSide' -> true} asDictionary} asDictionary.
			targetObject := call result targetObject.
			self assert: targetObject class equals: GtLMissingArgumentDomainObject.
			self
				assert: targetObject errorMessage
				equals: ('{1} class>>#newClassTraitMethod is a new method: provide a protocol for it'
						format: {subjects trait name}).
			self
				assert: (subjects trait classSide includesLocalSelector: #newClassTraitMethod) not.
			call ]
]

{ #category : #examples }
GtLMagritteToolForMethodCompilationExamples >> compileNewMethodWithoutProtocol [
	"A new method needs a protocol, otherwise it would end up as yet unclassified; it is not compiled"

	<gtExample>
	| selector targetClass |
	selector := #gtMagritteCompiledExampleUnclassified.
	targetClass := GtLMagritteToolForMethodCompilationExamples.
	(targetClass includesSelector: selector)
		ifTrue: [ targetClass removeSelector: selector ].
	[ | call targetObject |
	call := self
			executeTool: GtLMagritteToolForMethodCompilation new
			withArguments: {'methodRequest'
						-> {'methodClassName' -> targetClass name asString.
								'sourceCode' -> 'gtMagritteCompiledExampleUnclassified ^ 42'.
								'classSide' -> false} asDictionary} asDictionary.
	targetObject := call result targetObject.
	self assert: targetObject class equals: GtLMissingArgumentDomainObject.
	self assert: targetObject missingArgument equals: 'protocol'.
	self
		assert: targetObject errorMessage
		equals: 'GtLMagritteToolForMethodCompilationExamples>>#gtMagritteCompiledExampleUnclassified is a new method: provide a protocol for it'.
	self assert: (targetClass includesSelector: selector) not.
	^ call ]
		ensure: [ (targetClass includesSelector: selector)
				ifTrue: [ targetClass removeSelector: selector ] ]
]

{ #category : #examples }
GtLMagritteToolForMethodCompilationExamples >> compileOverridingTraitMethod [
	"Compiling a trait method in a class that uses the trait adds a new overriding method; the trait keeps its method"

	<gtExample>
	^ GtLTraitMethodExamplesSubjects new
		during: [ :subjects | 
			| call targetObject |
			call := self
					executeTool: GtLMagritteToolForMethodCompilation new
					withArguments: {'methodRequest'
								-> {'methodClassName' -> subjects traitUser name asString.
										'sourceCode' -> 'traitMethod ^ 7'.
										'protocol' -> 'examples'.
										'classSide' -> false} asDictionary} asDictionary.
			targetObject := call result targetObject.
			self assert: (targetObject isKindOf: GtLMethodCompilationResult).
			self assert: targetObject status equals: 'compiled'.
			self assert: targetObject oldMethod isNil.
			self
				assert: targetObject newMethod methodReference methodClassName
				equals: subjects traitUser name asString.
			self assert: (subjects traitUser includesLocalSelector: #traitMethod).
			self assert: subjects traitUser new traitMethod equals: 7.
			self assert: subjects composedTraitUser new traitMethod equals: 42.
			call ]
]

{ #category : #examples }
GtLMagritteToolForMethodCompilationExamples >> compileOverridingTraitMethodWithoutProtocol [
	"An override of a trait method is a new method of the class, so it needs a protocol; without one it is not compiled"

	<gtExample>
	^ GtLTraitMethodExamplesSubjects new
		during: [ :subjects | 
			| call targetObject |
			call := self
					executeTool: GtLMagritteToolForMethodCompilation new
					withArguments: {'methodRequest'
								-> {'methodClassName' -> subjects traitUser name asString.
										'sourceCode' -> 'traitMethod ^ 7'.
										'classSide' -> false} asDictionary} asDictionary.
			targetObject := call result targetObject.
			self assert: targetObject class equals: GtLMissingArgumentDomainObject.
			self assert: targetObject missingArgument equals: 'protocol'.
			self assert: (subjects traitUser includesLocalSelector: #traitMethod) not.
			self assert: subjects traitUser new traitMethod equals: 42.
			call ]
]
