Class {
	#name : #GtLRefactoringToolForMethodReferencesExamples,
	#superclass : #GtLAbstractRefactoringMagritteToolExamples,
	#category : #'Gt4LlmCore-Examples-Tools'
}

{ #category : #examples }
GtLRefactoringToolForMethodReferencesExamples >> methodReferencesForExistingSelector [
	<gtExample>
	| tool call targetObject references |
	tool := self toolWithExampleSenders.
	call := self
		executeTool: tool
		withArguments: {'selector' -> 'bar'} asDictionary.
	targetObject := call result targetObject.
	self assert: targetObject isErrorDomainObject not.
	references := targetObject references
			detect: [ :each | 
				each methodClass name = 'GtLRefactoringMethodReferencesSender'
					and: [ each selector = 'call' ] ].
	self assert: references isNotNil.
	references := targetObject references
			detect: [ :each | 
				each methodClass name = 'GtLRefactoringMethodReferencesForwarder'
					and: [ each selector = 'call' ] ].
	self assert: references isNotNil.
	^ call
]

{ #category : #examples }
GtLRefactoringToolForMethodReferencesExamples >> methodReferencesForUnknownSelector [
	<gtExample>
	| tool call targetObject |
	tool := self toolWithExampleSenders.
	call := self
		executeTool: tool
		withArguments: {'selector' -> 'missingSelector'} asDictionary.
	targetObject := call result targetObject.
	self assert: targetObject isErrorDomainObject not.
	self assert: targetObject methodName equals: 'missingSelector'.
	self assert: targetObject references equals: #().
	^ call
]

{ #category : #'llm-generated' }
GtLRefactoringToolForMethodReferencesExamples >> toolWithExampleSenders [
	| namespace tool senderClass forwarderClass |
	namespace := GtRBNamespace new.
	namespace defineClass: 'Object subclass: #GtLRefactoringMethodReferencesSender
		instanceVariableNames: ''''''
		classVariableNames: ''''''
		package: ''DemoTest''' .
	namespace defineClass: 'Object subclass: #GtLRefactoringMethodReferencesForwarder
		instanceVariableNames: ''''''
		classVariableNames: ''''''
		package: ''DemoTest''' .
	senderClass := namespace classNamed: 'GtLRefactoringMethodReferencesSender'.
	forwarderClass := namespace classNamed: 'GtLRefactoringMethodReferencesForwarder'.
	senderClass compile: 'bar
	^ 1' classified: 'examples'.
	senderClass compile: 'call
	^ self bar' classified: 'examples'.
	forwarderClass compile: 'call
	^ GtLRefactoringMethodReferencesSender new bar' classified: 'examples'.
	tool := GtLRefactoringToolForMethodReferences new.
	tool model: namespace.
	^ tool
]
