"
Examples for GtLMagritteToolForMethodRemoval.
"
Class {
	#name : #GtLMagritteToolForMethodRemovalExamples,
	#superclass : #GtLAbstractMagritteFunctionToolExamples,
	#category : 'Gt4LlmCore-Examples-Tools'
}

{ #category : #private }
GtLMagritteToolForMethodRemovalExamples >> createSubjectClass [
	self removeClassNamedIfPresent: self subjectClassName.
	^ Object
		subclass: self subjectClassName
		instanceVariableNames: ''
		classVariableNames: ''
		package: 'Gt4LlmCore-Examples'
]

{ #category : #private }
GtLMagritteToolForMethodRemovalExamples >> removeClassNamedIfPresent: aSymbol [
	Smalltalk globals
		at: aSymbol asSymbol
		ifPresent: [ :cls | cls removeFromSystem ]
]

{ #category : #examples }
GtLMagritteToolForMethodRemovalExamples >> removeClassSideMethod [
	<gtExample>
	| tool domainObject |
	[
		| class methodSelector |
		class := self createSubjectClass.
		methodSelector := #temporaryClassMethod.
		class class compile: 'temporaryClassMethod ^ 21'.
		tool := GtLMagritteToolForMethodRemoval new.
		domainObject := self
			executeTool: tool
			withArguments: {
				'methodDescriptor' -> {
					'methodClassName' -> class name asString.
					'methodName' -> methodSelector asString.
					'classSide' -> true
				} asDictionary
			} asDictionary.
		self assert: (domainObject isKindOf: GtLMethodRemovalResult).
		self assert: domainObject status equals: 'removed'.
		self assert: domainObject removedMethod methodName equals: methodSelector asString.
		self assert: domainObject removedMethod isClassSide.
		self assert: (class class includesSelector: methodSelector) not
	] ensure: [ self removeClassNamedIfPresent: self subjectClassName ].
	^ domainObject
]

{ #category : #examples }
GtLMagritteToolForMethodRemovalExamples >> removeInstanceMethod [
	<gtExample>
	| tool domainObject |
	[
		| class methodSelector |
		class := self createSubjectClass.
		methodSelector := #temporaryInstanceMethod.
		class compile: 'temporaryInstanceMethod ^ 42'.
		tool := GtLMagritteToolForMethodRemoval new.
		domainObject := self
			executeTool: tool
			withArguments: {
				'methodDescriptor' -> {
					'methodClassName' -> class name asString.
					'methodName' -> methodSelector asString.
					'classSide' -> false
				} asDictionary
			} asDictionary.
		self assert: (domainObject isKindOf: GtLMethodRemovalResult).
		self assert: domainObject status equals: 'removed'.
		self assert: domainObject removedMethod methodName equals: methodSelector asString.
		self assert: domainObject removedMethod methodClassName equals: class name asString.
		self assert: (class includesSelector: methodSelector) not
	] ensure: [ self removeClassNamedIfPresent: self subjectClassName ].
	^ domainObject
]

{ #category : #examples }
GtLMagritteToolForMethodRemovalExamples >> removeMethodFromUnknownClass [
	<gtExample>
	| tool domainObject |
	tool := GtLMagritteToolForMethodRemoval new.
	domainObject := self
		executeTool: tool
		withArguments: {
			'methodDescriptor' -> {
				'methodClassName' -> 'NonExistingClassName42'.
				'methodName' -> 'someMethod'.
				'classSide' -> false
			} asDictionary
		} asDictionary.
	self 
		assertMissingObject: domainObject 
		withObjectName: 'NonExistingClassName42' 
		errorMessage: 'NonExistingClassName42 is not found'.
	^ domainObject
]

{ #category : #examples }
GtLMagritteToolForMethodRemovalExamples >> removeMethodMissingArgument [
	<gtExample>
	| tool domainObject |
	tool := GtLMagritteToolForMethodRemoval new.
	domainObject := self
		executeTool: tool
		withArguments: Dictionary new.
	self 
		assertMissingRequiredProperties: domainObject 
		withPropertyNames: #('methodDescriptor') 
		path: #(nil) 
		errorMessage: 'required properties missing [methodDescriptor]'.
	^ domainObject
]

{ #category : #examples }
GtLMagritteToolForMethodRemovalExamples >> removeUnknownMethod [
	<gtExample>
	| tool domainObject |
	[
		| class methodSelector expectedSignature |
		class := self createSubjectClass.
		methodSelector := #methodThatDoesNotExist.
		tool := GtLMagritteToolForMethodRemoval new.
		domainObject := self
			executeTool: tool
			withArguments: {
				'methodDescriptor' -> {
					'methodClassName' -> class name asString.
					'methodName' -> methodSelector asString.
					'classSide' -> false
				} asDictionary
			} asDictionary.
		expectedSignature := class name asString , '>>#' , methodSelector asString.
		self 
			assertMissingObject: domainObject 
			withObjectName: expectedSignature 
			errorMessage: expectedSignature , ' is not found'
	] ensure: [ self removeClassNamedIfPresent: self subjectClassName ].
	^ domainObject
]

{ #category : #private }
GtLMagritteToolForMethodRemovalExamples >> subjectClassName [
	^ #GtLMagritteToolForMethodRemovalExamplesSubject
]
