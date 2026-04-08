"
Examples for GtLMagritteToolForMethodsRemoval.
"
Class {
	#name : #GtLMagritteToolForMethodsRemovalExamples,
	#superclass : #GtLAbstractMagritteFunctionToolExamples,
	#category : 'Gt4LlmCore-Examples-Tools'
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
	| tool domainObject |
	[
		| class instanceSelector classSelector |
		class := self createSubjectClass.
		instanceSelector := #temporaryMixedInstance.
		classSelector := #temporaryMixedClass.
		class compile: 'temporaryMixedInstance ^ 9'.
		class class compile: 'temporaryMixedClass ^ 10'.
		tool := GtLMagritteToolForMethodsRemoval new.
		domainObject := self
			executeTool: tool
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
		self assert: (domainObject isKindOf: GtLMethodsRemovalResult).
		self assert: domainObject methods size equals: 2.
		self assert: (class includesSelector: instanceSelector) not.
		self assert: (class class includesSelector: classSelector) not.
		self assert: domainObject methods first status equals: 'removed'.
		self assert: domainObject methods second status equals: 'removed'
	] ensure: [ self removeClassNamedIfPresent: self subjectClassName ].
	^ domainObject
]

{ #category : #examples }
GtLMagritteToolForMethodsRemovalExamples >> removeInstanceSideMethods [
	<gtExample>
	| tool domainObject |
	[
		| class methodSelectorOne methodSelectorTwo |
		class := self createSubjectClass.
		methodSelectorOne := #temporaryInstanceMethodOne.
		methodSelectorTwo := #temporaryInstanceMethodTwo.
		class compile: 'temporaryInstanceMethodOne ^ 1'.
		class compile: 'temporaryInstanceMethodTwo ^ 2'.
		tool := GtLMagritteToolForMethodsRemoval new.
		domainObject := self
			executeTool: tool
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
		self assert: (domainObject isKindOf: GtLMethodsRemovalResult).
		self assert: domainObject methods size equals: 2.
		self assert: (class includesSelector: methodSelectorOne) not.
		self assert: (class includesSelector: methodSelectorTwo) not.
		self assert: domainObject methods first status equals: 'removed'.
		self assert: domainObject methods second status equals: 'removed'
	] ensure: [ self removeClassNamedIfPresent: self subjectClassName ].
	^ domainObject
]

{ #category : #examples }
GtLMagritteToolForMethodsRemovalExamples >> removeMethodsMissingArgument [
	<gtExample>
	| tool domainObject |
	tool := GtLMagritteToolForMethodsRemoval new.
	domainObject := self
		executeTool: tool
		withArguments: Dictionary new.
	self 
		assertMissingRequiredProperties: domainObject 
		withPropertyNames: #('methods') 
		path: #(nil) 
		errorMessage: 'required properties missing [methods]'.
	^ domainObject
]

{ #category : #examples }
GtLMagritteToolForMethodsRemovalExamples >> removeUnknownMethod [
	<gtExample>
	| tool domainObject |
	[
		| class methodSelector expectedSignature |
		class := self createSubjectClass.
		methodSelector := #missingMethod.
		tool := GtLMagritteToolForMethodsRemoval new.
		domainObject := self
			executeTool: tool
			withArguments: {
				'methods' -> {
					{'methodClassName' -> class name asString.
					 'methodName' -> methodSelector asString.
					 'classSide' -> false} asDictionary
				} asArray
			} asDictionary.
		self assert: (domainObject isKindOf: GtLMethodsRemovalResult).
		self assert: domainObject methods size equals: 1.
		self assert: domainObject methods first isErrorDomainObject.
		expectedSignature := class name asString , '>>#' , methodSelector asString.
		self assert: domainObject methods first objectName equals: expectedSignature
	] ensure: [ self removeClassNamedIfPresent: self subjectClassName ].
	^ domainObject
]

{ #category : #private }
GtLMagritteToolForMethodsRemovalExamples >> subjectClassName [
	^ #GtLMagritteToolForMethodsRemovalExamplesSubject
]
