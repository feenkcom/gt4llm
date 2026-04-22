"
Examples for GtLMagritteToolForMethodsRemoval.
"
Class {
	#name : #GtLMagritteToolForMethodsRemovalExamples,
	#superclass : #GtLAbstractMagritteFunctionToolExamples,
	#category : #'Gt4LlmCore-Examples-Tools'
}

{ #category : #private }
GtLMagritteToolForMethodsRemovalExamples >> createSubjectClass [
	self removeClassNamedIfPresent: self subjectClassName.
	^ Object
		subclass: self subjectClassName
		instanceVariableNames: ''
		classVariableNames: ''
		package: 'Gt4LlmCore-Examples'
]

{ #category : #private }
GtLMagritteToolForMethodsRemovalExamples >> removeClassNamedIfPresent: aSymbol [
	Smalltalk globals
		at: aSymbol asSymbol
		ifPresent: [ :cls | cls removeFromSystem ]
]

{ #category : #examples }
GtLMagritteToolForMethodsRemovalExamples >> removeClassSideAndInstanceMethod [
	<gtExample>
	| call |
	[
		| class instanceSelector classSelector targetObject |
		class := self createSubjectClass.
		instanceSelector := #temporaryMixedInstance.
		classSelector := #temporaryMixedClass.
		class compile: 'temporaryMixedInstance ^ 9'.
		class class compile: 'temporaryMixedClass ^ 10'.
		call := self
			executeTool: GtLMagritteToolForMethodsRemoval new
			withArguments: {
				'methods' -> {
					{'methodClassName' -> class name asString.
					 'methodName' -> instanceSelector asString.
					 'classSide' -> false} asDictionary.
					{'methodClassName' -> class name asString.
					 'methodName' -> classSelector asString.
					 'classSide' -> true} asDictionary
				} asArray
			} asDictionary.
		targetObject := call result targetObject.
		self assert: (targetObject isKindOf: GtLMethodsRemovalResult).
		self assert: targetObject methods size equals: 2.
		self assert: (class includesSelector: instanceSelector) not.
		self assert: (class class includesSelector: classSelector) not.
		self assert: targetObject methods first status equals: 'removed'.
		self assert: targetObject methods second status equals: 'removed'
	] ensure: [ self removeClassNamedIfPresent: self subjectClassName ].
	^ call
]

{ #category : #examples }
GtLMagritteToolForMethodsRemovalExamples >> removeInstanceSideMethods [
	<gtExample>
	| call |
	[
		| class methodSelectorOne methodSelectorTwo targetObject |
		class := self createSubjectClass.
		methodSelectorOne := #temporaryInstanceMethodOne.
		methodSelectorTwo := #temporaryInstanceMethodTwo.
		class compile: 'temporaryInstanceMethodOne ^ 1'.
		class compile: 'temporaryInstanceMethodTwo ^ 2'.
		call := self
			executeTool: GtLMagritteToolForMethodsRemoval new
			withArguments: {
				'methods' -> {
					{'methodClassName' -> class name asString.
					 'methodName' -> methodSelectorOne asString.
					 'classSide' -> false} asDictionary.
					{'methodClassName' -> class name asString.
					 'methodName' -> methodSelectorTwo asString.
					 'classSide' -> false} asDictionary
				} asArray
			} asDictionary.
		targetObject := call result targetObject.
		self assert: (targetObject isKindOf: GtLMethodsRemovalResult).
		self assert: targetObject methods size equals: 2.
		self assert: (class includesSelector: methodSelectorOne) not.
		self assert: (class includesSelector: methodSelectorTwo) not.
		self assert: targetObject methods first status equals: 'removed'.
		self assert: targetObject methods second status equals: 'removed'
	] ensure: [ self removeClassNamedIfPresent: self subjectClassName ].
	^ call
]

{ #category : #examples }
GtLMagritteToolForMethodsRemovalExamples >> removeMethodsMissingArgument [
	<gtExample>
	| call |
	call := self
		executeTool: GtLMagritteToolForMethodsRemoval new
		withArguments: Dictionary new.
	self 
		assertMissingRequiredProperties: call result targetObject 
		withPropertyNames: #('methods') 
		path: #(nil) 
		errorMessage: 'required properties missing [methods]'.
	^ call
]

{ #category : #examples }
GtLMagritteToolForMethodsRemovalExamples >> removeUnknownMethod [
	<gtExample>
	| call |
	[
		| class methodSelector expectedSignature |
		class := self createSubjectClass.
		methodSelector := #missingMethod.
		call := self
			executeTool: GtLMagritteToolForMethodsRemoval new
			withArguments: {
				'methods' -> {
					{'methodClassName' -> class name asString.
					 'methodName' -> methodSelector asString.
					 'classSide' -> false} asDictionary
				} asArray
			} asDictionary.
		self assert: (call result targetObject isKindOf: GtLMethodsRemovalResult).
		self assert: call result targetObject methods size equals: 1.
		self assert: call result targetObject methods first isErrorDomainObject.
		expectedSignature := class name asString , '>>#' , methodSelector asString.
		self assert: call result targetObject methods first objectName equals: expectedSignature
	] ensure: [ self removeClassNamedIfPresent: self subjectClassName ].
	^ call
]

{ #category : #private }
GtLMagritteToolForMethodsRemovalExamples >> subjectClassName [
	^ #GtLMagritteToolForMethodsRemovalExamplesSubject
]
