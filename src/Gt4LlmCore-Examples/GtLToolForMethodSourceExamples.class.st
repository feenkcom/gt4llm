Class {
	#name : #GtLToolForMethodSourceExamples,
	#superclass : #Object,
	#category : #'Gt4LlmCore-Examples-Tools'
}

{ #category : #'llm-generated' }
GtLToolForMethodSourceExamples >> methodSourceForExistingClassSideMethod [
	<gtExample>
	| tool call result |
	tool := GtLToolForMethodSource new.
	call := GtLFunctionToolCall new.
	call function: {
		'name' -> tool name.
		'arguments' -> {
			'className' -> #GtLlmChat.
			'methodName' -> #leJsonV4Name.
			'classSide' -> 'true'
		} asDictionary
	} asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: result equals: (GtLlmChat class>>#leJsonV4Name) sourceCode.
	^ tool
]

{ #category : #'llm-generated' }
GtLToolForMethodSourceExamples >> methodSourceForExistingInstanceSideMethod [
	<gtExample>
	| tool call result |
	tool := GtLToolForMethodSource new.
	call := GtLFunctionToolCall new.
	call function: {
		'name' -> tool name.
		'arguments' -> {
			'className' -> #GtLlmToolForMethodImplementors.
			'methodName' -> #privatePerformToolCall:.
			'classSide' -> 'false'
		} asDictionary
	} asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: result equals: (GtLlmToolForMethodImplementors>>#privatePerformToolCall:) sourceCode.
	^ tool
]

{ #category : #'llm-generated' }
GtLToolForMethodSourceExamples >> methodSourceForUnknownClass [
	<gtExample>
	| tool call result |
	tool := GtLToolForMethodSource new.
	call := GtLFunctionToolCall new.
	call function: {
		'name' -> tool name.
		'arguments' -> {
			'className' -> #ClassThatDoesNotExist.
			'methodName' -> 'unknownSelector42'.
			'classSide' -> 'class'
		} asDictionary
	} asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: result equals: 'Class not found'.
	^ tool
]

{ #category : #'llm-generated' }
GtLToolForMethodSourceExamples >> methodSourceForUnknownClassSideMethod [
	<gtExample>
	| tool call result |
	tool := GtLToolForMethodSource new.
	call := GtLFunctionToolCall new.
	call function: {
		'name' -> tool name.
		'arguments' -> {
			'className' -> #GtLlmToolForMethodImplementors.
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
GtLToolForMethodSourceExamples >> methodSourceForUnknownInstanceSideMethod [
	<gtExample>
	| tool call result |
	tool := GtLToolForMethodSource new.
	call := GtLFunctionToolCall new.
	call function: {
		'name' -> tool name.
		'arguments' -> {
			'className' -> #GtLlmToolForMethodImplementors.
			'methodName' -> 'unknownSelector42'.
			'classSide' -> 'false'
		} asDictionary
	} asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: result equals: 'Method not found'.
	^ tool
]
