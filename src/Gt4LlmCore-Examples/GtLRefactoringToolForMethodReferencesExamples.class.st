Class {
	#name : #GtLRefactoringToolForMethodReferencesExamples,
	#superclass : #GtLAbstractRefactoringMagritteToolExamples,
	#category : #'Gt4LlmCore-Examples-Tools'
}

{ #category : #examples }
GtLRefactoringToolForMethodReferencesExamples >> methodReferencesForExistingSelector [
	<gtExample>
	| tool call result references |
	tool := self toolWithExampleSenders.
	call := GtLFunctionToolCall new.
	call rawArguments: {'selector' -> 'bar'} asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: result isErrorDomainObject not.
	references := result targetObject references
			detect: [ :each | 
				each methodClass name = 'GtLRefactoringMethodReferencesSender'
					and: [ each selector = 'call' ] ].
	self assert: references isNotNil.
	references := result targetObject references
			detect: [ :each | 
				each methodClass name = 'GtLRefactoringMethodReferencesForwarder'
					and: [ each selector = 'call' ] ].
	self assert: references isNotNil.
	^ call
]

{ #category : #examples }
GtLRefactoringToolForMethodReferencesExamples >> methodReferencesForUnknownSelector [
	<gtExample>
	| tool call result |
	tool := self toolWithExampleSenders.
	call := GtLFunctionToolCall new.
	call rawArguments: {'selector' -> 'missingSelector'} asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	
	self assert: result isErrorDomainObject not.
	self assert: result targetObject methodName equals: 'missingSelector'.
	self assert: result targetObject references equals: #().
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
