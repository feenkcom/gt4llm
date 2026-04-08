Class {
	#name : #GtLRefactoringToolForMethodImplementorsExamples,
	#superclass : #GtLAbstractRefactoringMagritteToolExamples,
	#category : 'Gt4LlmCore-Examples-Tools'
}

{ #category : #examples }
GtLRefactoringToolForMethodImplementorsExamples >> methodImplementorsForExistingSelector [
	<gtExample>
	| tool call targetObject implementor |
	tool := self toolWithExampleHierarchy.
	call := self
		executeTool: tool
		withArguments: {'methodName' -> 'example'} asDictionary.
	targetObject := call result targetObject.
	self assert: targetObject isErrorDomainObject not.
	implementor := targetObject implementors
			detect: [ :each | each name = 'GtLRefactoringMethodImplementorsBase' ].
	self assert: implementor isNotNil.
	implementor := targetObject implementors
			detect: [ :each | each name = 'GtLRefactoringMethodImplementorsChild' ].
	self assert: implementor isNotNil.
	^ call
]

{ #category : #examples }
GtLRefactoringToolForMethodImplementorsExamples >> methodImplementorsForUnknownSelector [
	<gtExample>
	| tool call targetObject |
	tool := self toolWithExampleHierarchy.
	call := self
		executeTool: tool
		withArguments: {'methodName' -> 'missingSelector'} asDictionary.
	targetObject := call result targetObject.
	self assert: targetObject isErrorDomainObject not.
	self assert: targetObject methodName equals: 'missingSelector'.
	self assert: targetObject implementors equals: #().
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
