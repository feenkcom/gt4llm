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
	| call |
	[
		| class methodSelector targetObject |
		class := self createSubjectClass.
		methodSelector := #temporaryClassMethod.
		class class compile: 'temporaryClassMethod ^ 21'.
		call := self
			executeTool: GtLMagritteToolForMethodRemoval new
			withArguments: {
				'methodDescriptor' -> {
					'methodClassName' -> class name asString.
					'methodName' -> methodSelector asString.
					'classSide' -> true
				} asDictionary
			} asDictionary.
		targetObject := call result targetObject.
		self assert: (targetObject isKindOf: GtLMethodRemovalResult).
		self assert: targetObject status equals: 'removed'.
		self assert: targetObject removedMethod methodName equals: methodSelector asString.
		self assert: targetObject removedMethod isClassSide.
		self assert: (class class includesSelector: methodSelector) not
	] ensure: [ self removeClassNamedIfPresent: self subjectClassName ].
	^ call
]

{ #category : #examples }
GtLMagritteToolForMethodRemovalExamples >> removeInstanceMethod [
	<gtExample>
	| call |
	[
		| class methodSelector targetObject |
		class := self createSubjectClass.
		methodSelector := #temporaryInstanceMethod.
		class compile: 'temporaryInstanceMethod ^ 42'.
		call := self
			executeTool: GtLMagritteToolForMethodRemoval new
			withArguments: {
				'methodDescriptor' -> {
					'methodClassName' -> class name asString.
					'methodName' -> methodSelector asString.
					'classSide' -> false
				} asDictionary
			} asDictionary.
		targetObject := call result targetObject.
		self assert: (targetObject isKindOf: GtLMethodRemovalResult).
		self assert: targetObject status equals: 'removed'.
		self assert: targetObject removedMethod methodName equals: methodSelector asString.
		self assert: targetObject removedMethod methodClassName equals: class name asString.
		self assert: (class includesSelector: methodSelector) not
	] ensure: [ self removeClassNamedIfPresent: self subjectClassName ].
	^ call
]

{ #category : #examples }
GtLMagritteToolForMethodRemovalExamples >> removeMethodFromUnknownClass [
	<gtExample>
	| call |
	call := self
		executeTool: GtLMagritteToolForMethodRemoval new
		withArguments: {
			'methodDescriptor' -> {
				'methodClassName' -> 'NonExistingClassName42'.
				'methodName' -> 'someMethod'.
				'classSide' -> false
			} asDictionary
		} asDictionary.
	self 
		assertMissingObject: call result targetObject 
		withObjectName: 'NonExistingClassName42' 
		errorMessage: 'NonExistingClassName42 is not found'.
	^ call
]

{ #category : #examples }
GtLMagritteToolForMethodRemovalExamples >> removeMethodMissingArgument [
	<gtExample>
	| call |
	call := self
		executeTool: GtLMagritteToolForMethodRemoval new
		withArguments: Dictionary new.
	self 
		assertMissingRequiredProperties: call result targetObject 
		withPropertyNames: #('methodDescriptor') 
		path: #(nil) 
		errorMessage: 'required properties missing [methodDescriptor]'.
	^ call
]

{ #category : #examples }
GtLMagritteToolForMethodRemovalExamples >> removeUnknownMethod [
	<gtExample>
	| call |
	[
		| class methodSelector expectedSignature |
		class := self createSubjectClass.
		methodSelector := #methodThatDoesNotExist.
		call := self
			executeTool: GtLMagritteToolForMethodRemoval new
			withArguments: {
				'methodDescriptor' -> {
					'methodClassName' -> class name asString.
					'methodName' -> methodSelector asString.
					'classSide' -> false
				} asDictionary
			} asDictionary.
		expectedSignature := class name asString , '>>#' , methodSelector asString.
		self 
			assertMissingObject: call result targetObject 
			withObjectName: expectedSignature 
			errorMessage: expectedSignature , ' is not found'
	] ensure: [ self removeClassNamedIfPresent: self subjectClassName ].
	^ call
]

{ #category : #private }
GtLMagritteToolForMethodRemovalExamples >> subjectClassName [
	^ #GtLMagritteToolForMethodRemovalExamplesSubject
]
