"
Examples for GtLMagritteToolForMethodsRemoval.
"
Class {
	#name : #GtLMagritteToolForMethodsRemovalExamples,
	#superclass : #Object,
	#traits : 'TGtLInvalidInputDataAssertions',
	#classTraits : 'TGtLInvalidInputDataAssertions classTrait',
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
	| tool call result domainObject |
	[
		| class instanceSelector classSelector |
		class := self createSubjectClass.
		instanceSelector := #temporaryMixedInstance.
		classSelector := #temporaryMixedClass.
		class compile: 'temporaryMixedInstance ^ 9'.
		class class compile: 'temporaryMixedClass ^ 10'.
		tool := GtLMagritteToolForMethodsRemoval new.
		call := GtLFunctionToolCall new.
		call rawArguments: {
			'methods' -> {
				{'methodClassName' -> class name asString.
				 'methodName' -> instanceSelector asString.
				 'classSide' -> false} asDictionary.
				{'methodClassName' -> class name asString.
				 'methodName' -> classSelector asString.
				 'classSide' -> true} asDictionary
			} asArray
		} asDictionary.
		result := tool performToolCall: call.
		self assert: call tool == tool.
		self assert: (result isKindOf: GTLDataViewWrapperModel).
		domainObject := result targetObject.
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
	| tool call result domainObject |
	[
		| class methodSelectorOne methodSelectorTwo |
		class := self createSubjectClass.
		methodSelectorOne := #temporaryInstanceMethodOne.
		methodSelectorTwo := #temporaryInstanceMethodTwo.
		class compile: 'temporaryInstanceMethodOne ^ 1'.
		class compile: 'temporaryInstanceMethodTwo ^ 2'.
		tool := GtLMagritteToolForMethodsRemoval new.
		call := GtLFunctionToolCall new.
		call rawArguments: {
			'methods' -> {
				{'methodClassName' -> class name asString.
				 'methodName' -> methodSelectorOne asString.
				 'classSide' -> false} asDictionary.
				{'methodClassName' -> class name asString.
				 'methodName' -> methodSelectorTwo asString.
				 'classSide' -> false} asDictionary
			} asArray
		} asDictionary.
		result := tool performToolCall: call.
		self assert: call tool == tool.
		self assert: (result isKindOf: GTLDataViewWrapperModel).
		domainObject := result targetObject.
		self assert: (domainObject isKindOf: GtLMethodsRemovalResult).
		self assert: domainObject methods size equals: 2.
		self assert: (class includesSelector: methodSelectorOne) not.
		self assert: (class includesSelector: methodSelectorTwo) not.
		self assert: domainObject methods first status equals: 'removed'.
		self assert: domainObject methods second status equals: 'removed'
	] ensure: [ self removeClassNamedIfPresent: self subjectClassName ].
	^ domainObject
]

{ #category : #'examples - error conditions' }
GtLMagritteToolForMethodsRemovalExamples >> removeMethodsMissingArgument [
	<gtExample>
	| tool call result domainObject |
	tool := GtLMagritteToolForMethodsRemoval new.
	call := GtLFunctionToolCall new.
	call rawArguments: Dictionary new.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: (result isKindOf: GTLDataViewWrapperModel).
	domainObject := result targetObject.
	self 
		assertMissingRequiredProperties: domainObject 
		withPropertyNames: #('methods') 
		path: #(nil) 
		errorMessage: 'required properties missing [methods]'.
	^ domainObject
]

{ #category : #'examples - error conditions' }
GtLMagritteToolForMethodsRemovalExamples >> removeUnknownMethod [
	<gtExample>
	| tool call result domainObject |
	[
		| class methodSelector expectedSignature |
		class := self createSubjectClass.
		methodSelector := #missingMethod.
		tool := GtLMagritteToolForMethodsRemoval new.
		call := GtLFunctionToolCall new.
		call rawArguments: {
			'methods' -> {
				{'methodClassName' -> class name asString.
				 'methodName' -> methodSelector asString.
				 'classSide' -> false} asDictionary
			} asArray
		} asDictionary.
		result := tool performToolCall: call.
		self assert: call tool == tool.
		self assert: (result isKindOf: GTLDataViewWrapperModel).
		domainObject := result targetObject.
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
