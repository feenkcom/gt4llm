Class {
	#name : #GtLToolForClassActionsExamples,
	#superclass : #Object,
	#category : #'Gt4LlmCore-Examples-Tools'
}

{ #category : #'llm-generated' }
GtLToolForClassActionsExamples >> classActionsForClassWithNoActions [
	<gtExample>
	| tool call result |
	tool := GtLToolForClassActions new.
	call := GtLFunctionToolCall new.
	call
		function: {'name' -> tool name.
				'arguments'
					-> {'className' -> 'GtLToolForClassActionsExamples'} asDictionary}
				asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.

	self assert: result isErrorDomainObject not.
	self assert: result targetClass equals: GtLToolForClassActionsExamples.
	self assert: result methods equals: #().
	^ call
]

{ #category : #'llm-generated' }
GtLToolForClassActionsExamples >> classActionsForExistingClass [
	<gtExample>
	| tool call result |
	tool := GtLToolForClassActions new.
	call := GtLFunctionToolCall new.
	call
		function: {'name' -> tool name.
				'arguments' -> {'className' -> 'GtLudoRecordingGame'} asDictionary}
				asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: result isErrorDomainObject not.
	self assert: result methods isNotEmpty.
	self
		assert: (result methods
				anySatisfy: [ :eachMethod | eachMethod selector = 'gtAutoplayAction:' ]).
	^ call
]

{ #category : #'llm-generated' }
GtLToolForClassActionsExamples >> classActionsForUnknownClass [
	<gtExample>
	| tool call result |
	tool := GtLToolForClassActions new.
	call := GtLFunctionToolCall new.
	call
		function: {'name' -> tool name.
				'arguments' -> {'className' -> 'NonExistingClassName'} asDictionary}
				asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.

	self assert: result isErrorDomainObject.
	self assert: result objectName equals: 'NonExistingClassName'.
	^ call
]
