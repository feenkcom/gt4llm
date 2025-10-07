Class {
	#name : #GtLlmToolForMethodSourceExamples,
	#superclass : #Object,
	#category : #'Gt4Llm-Examples'
}

{ #category : #'llm-generated' }
GtLlmToolForMethodSourceExamples >> methodSourceForExistingClassSideMethod [
	<gtExample>
	| tool call result |
	tool := GtLlmToolForMethodSource new.
	call := GtLlmFunctionToolCall new.
	call function: {
		'name' -> tool name.
		'arguments' -> {
			'className' -> 'GtLlmChat'.
			'methodName' -> 'leJsonV4Name'.
			'classSide' -> 'true'
		} asDictionary
	} asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: result equals: (GtLlmChat class>>#leJsonV4Name) sourceCode.
	^ tool
]

{ #category : #'llm-generated' }
GtLlmToolForMethodSourceExamples >> methodSourceForExistingInstanceSideMethod [
	<gtExample>
	| tool call result |
	tool := GtLlmToolForMethodSource new.
	call := GtLlmFunctionToolCall new.
	call function: {
		'name' -> tool name.
		'arguments' -> {
			'className' -> 'GtLlmToolForImplementors'.
			'methodName' -> 'privatePerformToolCall:'.
			'classSide' -> 'false'
		} asDictionary
	} asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: result equals: (GtLlmToolForImplementors>>#privatePerformToolCall:) sourceCode.
	^ tool
]

{ #category : #'llm-generated' }
GtLlmToolForMethodSourceExamples >> methodSourceForUnknownClassSideMethod [
	<gtExample>
	| tool call result |
	tool := GtLlmToolForMethodSource new.
	call := GtLlmFunctionToolCall new.
	call function: {
		'name' -> tool name.
		'arguments' -> {
			'className' -> 'GtLlmToolForImplementors'.
			'methodName' -> 'unknownSelector42'.
			'classSide' -> 'class'
		} asDictionary
	} asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: result equals: 'Method not found'.
	^ tool
]

{ #category : #'llm-generated' }
GtLlmToolForMethodSourceExamples >> methodSourceForUnknownInstanceSideMethod [
	<gtExample>
	| tool call result |
	tool := GtLlmToolForMethodSource new.
	call := GtLlmFunctionToolCall new.
	call function: {
		'name' -> tool name.
		'arguments' -> {
			'className' -> 'GtLlmToolForImplementors'.
			'methodName' -> 'unknownSelector42'.
			'classSide' -> 'false'
		} asDictionary
	} asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: result equals: 'Method not found'.
	^ tool
]
