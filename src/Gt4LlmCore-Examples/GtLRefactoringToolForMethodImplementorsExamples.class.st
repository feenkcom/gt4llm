Class {
	#name : #GtLRefactoringToolForMethodImplementorsExamples,
	#superclass : #Object,
	#category : #'Gt4LlmCore-Examples-Tools'
}

{ #category : #'llm-generated' }
GtLRefactoringToolForMethodImplementorsExamples >> methodImplementorsForExistingSelector [
	<gtExample>
	| tool call result implementor |
	tool := self toolWithExampleHierarchy.
	call := GtLFunctionToolCall new.
	call
		function: {'name' -> tool name.
				'arguments' -> {'methodName' -> 'example'} asDictionary} asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: result isErrorDomainObject not.
	implementor := result implementors
			detect: [ :each | each name = 'GtLRefactoringMethodImplementorsBase' ].
	self assert: implementor isNotNil.
	implementor := result implementors
			detect: [ :each | each name = 'GtLRefactoringMethodImplementorsChild' ].
	self assert: implementor isNotNil.
	^ call
]

{ #category : #'llm-generated' }
GtLRefactoringToolForMethodImplementorsExamples >> methodImplementorsForUnknownSelector [
	<gtExample>
	| tool call result |
	tool := self toolWithExampleHierarchy.
	call := GtLFunctionToolCall new.
	call function: {
		'name' -> tool name.
		'arguments' -> {'methodName' -> 'missingSelector'} asDictionary
	} asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: result isErrorDomainObject not.
	self assert: result methodName equals: 'missingSelector'.
	self assert: result implementors equals: #().
	^ call
]

{ #category : #'llm-generated' }
GtLRefactoringToolForMethodImplementorsExamples >> toolWithExampleHierarchy [
	| namespace tool baseClass childClass |
	namespace := GtRBNamespace new.
	namespace defineClass: 'Object subclass: #GtLRefactoringMethodImplementorsBase
		instanceVariableNames: ''''''
		classVariableNames: ''''''
		package: ''DemoTest''' .
	namespace defineClass: 'GtLRefactoringMethodImplementorsBase subclass: #GtLRefactoringMethodImplementorsChild
		instanceVariableNames: ''''''
		classVariableNames: ''''''
		package: ''DemoTest''' .
	baseClass := namespace classNamed: 'GtLRefactoringMethodImplementorsBase'.
	childClass := namespace classNamed: 'GtLRefactoringMethodImplementorsChild'.
	baseClass compile: 'example
	^ 1' classified: 'examples'.
	childClass compile: 'example
	^ super example + 1' classified: 'examples'.
	tool := GtLRefactoringToolForMethodImplementors new.
	tool model: namespace.
	^ tool
]
