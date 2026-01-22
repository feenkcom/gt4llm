Class {
	#name : #GtLToolForMethodRemovalExamples,
	#superclass : #Object,
	#category : #'Gt4LlmCore-Examples'
}

{ #category : #helpers }
GtLToolForMethodRemovalExamples >> createSubjectClass [
	self removeClassNamedIfPresent: self subjectClassName.
	^ Object
		subclass: self subjectClassName
		instanceVariableNames: ''
		classVariableNames: ''
		package: 'Gt4LlmCore-Examples'
]

{ #category : #helpers }
GtLToolForMethodRemovalExamples >> removeClassNamedIfPresent: aSymbol [
	Smalltalk globals
		at: aSymbol asSymbol
		ifPresent: [ :cls | cls removeFromSystem ]
]

{ #category : #examples }
GtLToolForMethodRemovalExamples >> removeClassSideMethod [
	<gtExample>
	| tool call result class methodSelector |
	[
		class := self createSubjectClass.
		methodSelector := #temporaryClassMethod.
		class class compile: 'temporaryClassMethod ^ 21'.
		tool := GtLToolForMethodRemoval new.
		call := GtLFunctionToolCall new.
		call function: {
			'name' -> tool name.
			'arguments' -> {
				'className' -> class name.
				'methodName' -> methodSelector.
				'classSide' -> true
			} asDictionary
		} asDictionary.
		result := tool performToolCall: call.
		self assert: call tool == tool.
		self assert: result isErrorDomainObject not.
		self assert: (class class includesSelector: methodSelector) not.
		self assert: result method selector equals: methodSelector.
		self assert: result method methodClass == class class
	] ensure: [ self removeClassNamedIfPresent: self subjectClassName ].
	^ call
]

{ #category : #examples }
GtLToolForMethodRemovalExamples >> removeInstanceMethod [
	<gtExample>
	| tool call result class methodSelector |
	[
		class := self createSubjectClass.
		methodSelector := #temporaryInstanceMethod.
		class compile: 'temporaryInstanceMethod ^ 42'.
		tool := GtLToolForMethodRemoval new.
		call := GtLFunctionToolCall new.
		call function: {
			'name' -> tool name.
			'arguments' -> {
				'className' -> class name.
				'methodName' -> methodSelector
			} asDictionary
		} asDictionary.
		result := tool performToolCall: call.
		self assert: call tool == tool.
		self assert: result isErrorDomainObject not.
		self assert: (class includesSelector: methodSelector) not.
		self assert: result method selector equals: methodSelector.
		self assert: result method methodClass == class
	] ensure: [ self removeClassNamedIfPresent: self subjectClassName ].
	^ call
]

{ #category : #examples }
GtLToolForMethodRemovalExamples >> removeInstanceMethodWithClassSideFalse [
	<gtExample>
	| tool call result class methodSelector |
	[
		class := self createSubjectClass.
		methodSelector := #temporaryInstanceMethodFalseFlag.
		class compile: 'temporaryInstanceMethodFalseFlag ^ 7'.
		tool := GtLToolForMethodRemoval new.
		call := GtLFunctionToolCall new.
		call function: {
			'name' -> tool name.
			'arguments' -> {
				'className' -> class name.
				'methodName' -> methodSelector.
				'classSide' -> false
			} asDictionary
		} asDictionary.
		result := tool performToolCall: call.
		self assert: call tool == tool.
		self assert: result isErrorDomainObject not.
		self assert: (class includesSelector: methodSelector) not.
		self assert: result method selector equals: methodSelector.
		self assert: result method methodClass == class
	] ensure: [ self removeClassNamedIfPresent: self subjectClassName ].
	^ call
]

{ #category : #examples }
GtLToolForMethodRemovalExamples >> removeUnknownMethod [
	<gtExample>
	| tool call result class methodSelector |
	[
		class := self createSubjectClass.
		methodSelector := #methodThatDoesNotExist.
		tool := GtLToolForMethodRemoval new.
		call := GtLFunctionToolCall new.
		call function: {
			'name' -> tool name.
			'arguments' -> {
				'className' -> class name.
				'methodName' -> methodSelector
			} asDictionary
		} asDictionary.
		result := tool performToolCall: call.
		self assert: call tool == tool.
		self assert: result isErrorDomainObject.
		self assert: result objectName equals: (class name asString , '>>' , methodSelector asString)
	] ensure: [ self removeClassNamedIfPresent: self subjectClassName ].
	^ call
]

{ #category : #helpers }
GtLToolForMethodRemovalExamples >> subjectClassName [
	^ #GtLToolForMethodRemovalExamplesSubject
]
