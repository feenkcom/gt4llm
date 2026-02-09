Class {
	#name : #GtLToolForMethodsRemovalExamples,
	#superclass : #Object,
	#category : #'Gt4LlmCore-Examples'
}

{ #category : #support }
GtLToolForMethodsRemovalExamples >> createSubjectClass [
	self removeClassNamedIfPresent: self subjectClassName.
	^ Object
		subclass: self subjectClassName
		instanceVariableNames: ''
		classVariableNames: ''
		package: 'Gt4LlmCore-Examples'
]

{ #category : #support }
GtLToolForMethodsRemovalExamples >> removeClassNamedIfPresent: aSymbol [
	Smalltalk globals
		at: aSymbol asSymbol
		ifPresent: [ :cls | cls removeFromSystem ]
]

{ #category : #examples }
GtLToolForMethodsRemovalExamples >> removeClassSideAndInstanceMethod [
	<gtExample>
	| tool call result class instanceSelector classSelector |
	[
		class := self createSubjectClass.
		instanceSelector := #temporaryMixedInstance.
		classSelector := #temporaryMixedClass.
		class compile: 'temporaryMixedInstance ^ 9'.
		class class compile: 'temporaryMixedClass ^ 10'.
		tool := GtLToolForMethodsRemoval new.
		call := GtLFunctionToolCall new.
		call function: {
			'name' -> tool name.
			'arguments' -> {'methods' -> {
				{'className' -> class name.
					'methodName' -> instanceSelector.
					'classSide' -> false} asDictionary.
				{'className' -> class name.
					'methodName' -> classSelector.
					'classSide' -> true} asDictionary
			} asArray} asDictionary
		} asDictionary.
		result := tool performToolCall: call.
		self assert: call tool == tool.
		self assert: result isErrorDomainObject not.
		self assert: (class includesSelector: instanceSelector) not.
		self assert: (class class includesSelector: classSelector) not.
		self assert: result methods size equals: 2.
		self assert: result methods first isErrorDomainObject not.
		self assert: result methods second isErrorDomainObject not
	] ensure: [ self removeClassNamedIfPresent: self subjectClassName ].
	^ call
]

{ #category : #examples }
GtLToolForMethodsRemovalExamples >> removeInstanceSideMethods [
	<gtExample>
	| tool call result class methodSelectorOne methodSelectorTwo |
	[
		class := self createSubjectClass.
		methodSelectorOne := #temporaryInstanceMethodOne.
		methodSelectorTwo := #temporaryInstanceMethodTwo.
		class compile: 'temporaryInstanceMethodOne ^ 1'.
		class compile: 'temporaryInstanceMethodTwo ^ 2'.
		tool := GtLToolForMethodsRemoval new.
		call := GtLFunctionToolCall new.
		call function: {
			'name' -> tool name.
			'arguments' -> {'methods' -> {
				{'className' -> class name.
					'methodName' -> methodSelectorOne.
					'classSide' -> false} asDictionary.
				{'className' -> class name.
					'methodName' -> methodSelectorTwo.
					'classSide' -> false} asDictionary
			} asArray} asDictionary
		} asDictionary.
		result := tool performToolCall: call.
		self assert: call tool == tool.
		self assert: result isErrorDomainObject not.
		self assert: result methods size equals: 2.
		self assert: (class includesSelector: methodSelectorOne) not.
		self assert: (class includesSelector: methodSelectorTwo) not.
		self assert: result methods first isErrorDomainObject not.
		self assert: result methods second isErrorDomainObject not
	] ensure: [ self removeClassNamedIfPresent: self subjectClassName ].
	^ call
]

{ #category : #examples }
GtLToolForMethodsRemovalExamples >> removeUnknownMethod [
	<gtExample>
	| tool call result class methodSelector |
	[
		class := self createSubjectClass.
		methodSelector := #missingMethod.
		tool := GtLToolForMethodsRemoval new.
		call := GtLFunctionToolCall new.
		call function: {
			'name' -> tool name.
			'arguments' -> {'methods' -> {
				{'className' -> class name.
					'methodName' -> methodSelector.
					'classSide' -> false} asDictionary
			} asArray} asDictionary
		} asDictionary.
		result := tool performToolCall: call.
		self assert: call tool == tool.
		self assert: result isErrorDomainObject not.
		self assert: result methods size equals: 1.
		self assert: result methods first isErrorDomainObject.
		self assert: result methods first objectName equals: (class name asString , '>>' , methodSelector asString)
	] ensure: [ self removeClassNamedIfPresent: self subjectClassName ].
	^ call
]

{ #category : #support }
GtLToolForMethodsRemovalExamples >> subjectClassName [
	^ #GtLToolForMethodsRemovalExamplesSubject
]
